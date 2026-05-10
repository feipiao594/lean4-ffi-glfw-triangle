import Init.Data.FloatArray
import GlfwLean

def windowWidth : UInt32 := 600
def windowHeight : UInt32 := 600

def failNow {α : Type} (msg : String) : IO α :=
  throw <| IO.userError msg

def ensureOrFail (ok : Bool) (msg : String) : IO Unit := do
  unless ok do
    failNow msg

def compileShaderOrFail (shaderType : UInt32) (label source : String) : IO UInt32 := do
  let shader <- glCreateShader shaderType
  ensureOrFail (shader != 0) s!"glCreateShader returned 0 for {label}"
  glShaderSource shader source
  glCompileShader shader
  unless (<- glGetShaderCompileStatus shader) do
    let log <- glGetShaderInfoLog shader
    glDeleteShader shader
    failNow s!"{label} compilation failed:\n{log}"
  pure shader

def linkProgramOrFail (vertexShader fragmentShader : UInt32) : IO UInt32 := do
  let program <- glCreateProgram
  ensureOrFail (program != 0) "glCreateProgram returned 0"
  glAttachShader program vertexShader
  glAttachShader program fragmentShader
  glLinkProgram program
  unless (<- glGetProgramLinkStatus program) do
    let log <- glGetProgramInfoLog program
    glDeleteProgram program
    failNow s!"Program link failed:\n{log}"
  pure program

def getUniformLocationOrFail (program : UInt32) (name : String) : IO Int := do
  let location <- glGetUniformLocation program name
  ensureOrFail (location >= 0) s!"Uniform not found: {name}"
  pure location

def setupTriangleGeometry (vertices : FloatArray) : IO (UInt32 × UInt32) := do
  let vao <- glGenVertexArray
  let vbo <- glGenBuffer
  ensureOrFail (vao != 0) "glGenVertexArray returned 0"
  ensureOrFail (vbo != 0) "glGenBuffer returned 0"
  glBindVertexArray vao
  glBindArrayBuffer vbo
  glBufferDataFloatArray glArrayBuffer vertices glStaticDraw
  glVertexAttribPointerFloat
    vertexPositionAttribIndex
    vertexPositionComponentCount
    vertexStrideBytes
    vertexOffsetBytes
  glEnableVertexAttribArray vertexPositionAttribIndex
  glVertexAttribPointerFloat
    vertexColorAttribIndex
    vertexColorComponentCount
    vertexStrideBytes
    colorOffsetBytes
  glEnableVertexAttribArray vertexColorAttribIndex
  pure (vao, vbo)

def setupGlfwWindow : IO Window := do
  glfwWindowHint glfwContextVersionMajor requestedGLMajor
  glfwWindowHint glfwContextVersionMinor requestedGLMinor
  glfwWindowHint glfwOpenGLProfile glfwOpenGLCoreProfile
  glfwWindowHint glfwOpenGLForwardCompat swapIntervalEnabled
  let win <- glfwCreateWindow windowWidth windowHeight "Lean Triangle"
  if <- glfwWindowIsNull win then
    let err <- glfwGetErrorString
    failNow s!"Cannot create GLFW window: {err}"
  glfwShowWindow win
  glfwMakeContextCurrent win
  glfwSwapInterval swapIntervalEnabled
  pure win

def renderLoop (win : Window) (rotationLocation : Int) : IO Unit := do
  glViewport windowWidth windowHeight
  while (not (<- glfwWindowShouldClose win)) do
    let time <- glfwGetTime
    glUniform1f rotationLocation time
    glClearColor 0.08 0.10 0.14 1.0
    glClear glColorBufferBit
    glDrawArrays glTriangles drawFirstVertex triangleVertexCount
    glfwSwapBuffers win
    glfwPollEvents

def triangleVertices : FloatArray :=
  [ 0.0, 0.65, 0.0, 1.0, 0.2, 0.2
  , -0.65, -0.45, 0.0, 0.2, 1.0, 0.4
  , 0.65, -0.45, 0.0, 0.2, 0.5, 1.0
  ].toFloatArray

def vertexShaderSource : String :=
  "#version 330 core\n" ++
  "layout (location = 0) in vec3 aPos;\n" ++
  "layout (location = 1) in vec3 aColor;\n" ++
  "out vec3 vColor;\n" ++
  "uniform float uAngle;\n" ++
  "void main() {\n" ++
  "  float c = cos(uAngle);\n" ++
  "  float s = sin(uAngle);\n" ++
  "  vec2 rotated = vec2(\n" ++
  "    aPos.x * c - aPos.y * s,\n" ++
  "    aPos.x * s + aPos.y * c\n" ++
  "  );\n" ++
  "  gl_Position = vec4(rotated, aPos.z, 1.0);\n" ++
  "  vColor = aColor;\n" ++
  "}\n"

def fragmentShaderSource : String :=
  "#version 330 core\n" ++
  "in vec3 vColor;\n" ++
  "out vec4 FragColor;\n" ++
  "void main() {\n" ++
  "  FragColor = vec4(vColor, 1.0);\n" ++
  "}\n"

def main : IO Unit := do
  unless (<- glfwInit) do
    let err <- glfwGetErrorString
    failNow s!"Cannot initialize GLFW: {err}"
  try
    let win <- setupGlfwWindow
    let vertexShader <- compileShaderOrFail glVertexShader "Vertex shader" vertexShaderSource
    let fragmentShader <- compileShaderOrFail glFragmentShader "Fragment shader" fragmentShaderSource
    let program <- linkProgramOrFail vertexShader fragmentShader
    glDeleteShader vertexShader
    glDeleteShader fragmentShader
    glUseProgram program
    let rotationLocation <- getUniformLocationOrFail program "uAngle"
    let (vao, vbo) <- setupTriangleGeometry triangleVertices
    renderLoop win rotationLocation
    glDeleteBuffer vbo
    glDeleteVertexArray vao
    glDeleteProgram program
  finally
    glfwTerminate
