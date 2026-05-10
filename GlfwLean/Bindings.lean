import Init.Data.FloatArray

@[extern "lean_glfwInit"]
opaque glfwInit : IO Bool

@[extern "lean_glfwGetErrorString"]
opaque glfwGetErrorString : IO String

@[extern "lean_glfwTerminate"]
opaque glfwTerminate : IO Unit

@[extern "lean_glfwWindowHint"]
opaque glfwWindowHint (hint : UInt32) (value : UInt32) : IO Unit

opaque WindowP : NonemptyType
def Window := WindowP.type

@[extern "lean_glfwCreateWindow"]
opaque glfwCreateWindow (width : UInt32) (height : UInt32) (title : String) : IO Window

@[extern "lean_glfwWindowIsNull"]
opaque glfwWindowIsNull (win : Window) : IO Bool

@[extern "lean_glfwWindowShouldClose"]
opaque glfwWindowShouldClose (win : Window) : IO Bool

@[extern "lean_glfwShowWindow"]
opaque glfwShowWindow (win : Window) : IO Unit

@[extern "lean_glfwMakeContextCurrent"]
opaque glfwMakeContextCurrent (win : Window) : IO Unit

@[extern "lean_glfwSwapInterval"]
opaque glfwSwapInterval (interval : UInt32) : IO Unit

@[extern "lean_glfwSwapBuffers"]
opaque glfwSwapBuffers (win : Window) : IO Unit

@[extern "lean_glfwPollEvents"]
opaque glfwPollEvents : IO Unit

@[extern "lean_glfwGetTime"]
opaque glfwGetTime : IO Float

@[extern "lean_glCreateShader"]
opaque glCreateShader (shaderType : UInt32) : IO UInt32

@[extern "lean_glShaderSource"]
opaque glShaderSource (shader : UInt32) (source : String) : IO Unit

@[extern "lean_glCompileShader"]
opaque glCompileShader (shader : UInt32) : IO Unit

@[extern "lean_glGetShaderCompileStatus"]
opaque glGetShaderCompileStatus (shader : UInt32) : IO Bool

@[extern "lean_glGetShaderInfoLog"]
opaque glGetShaderInfoLog (shader : UInt32) : IO String

@[extern "lean_glDeleteShader"]
opaque glDeleteShader (shader : UInt32) : IO Unit

@[extern "lean_glCreateProgram"]
opaque glCreateProgram : IO UInt32

@[extern "lean_glAttachShader"]
opaque glAttachShader (program : UInt32) (shader : UInt32) : IO Unit

@[extern "lean_glLinkProgram"]
opaque glLinkProgram (program : UInt32) : IO Unit

@[extern "lean_glGetProgramLinkStatus"]
opaque glGetProgramLinkStatus (program : UInt32) : IO Bool

@[extern "lean_glGetProgramInfoLog"]
opaque glGetProgramInfoLog (program : UInt32) : IO String

@[extern "lean_glDeleteProgram"]
opaque glDeleteProgram (program : UInt32) : IO Unit

@[extern "lean_glUseProgram"]
opaque glUseProgram (program : UInt32) : IO Unit

@[extern "lean_glGetUniformLocation"]
opaque glGetUniformLocation (program : UInt32) (name : String) : IO Int

@[extern "lean_glUniform1f"]
opaque glUniform1f (location : Int) (value : Float) : IO Unit

@[extern "lean_glGenVertexArray"]
opaque glGenVertexArray : IO UInt32

@[extern "lean_glBindVertexArray"]
opaque glBindVertexArray (vao : UInt32) : IO Unit

@[extern "lean_glDeleteVertexArray"]
opaque glDeleteVertexArray (vao : UInt32) : IO Unit

@[extern "lean_glGenBuffer"]
opaque glGenBuffer : IO UInt32

@[extern "lean_glBindArrayBuffer"]
opaque glBindArrayBuffer (buffer : UInt32) : IO Unit

@[extern "lean_glBufferDataFloatArray"]
opaque glBufferDataFloatArray (target : UInt32) (data : FloatArray) (usage : UInt32) : IO Unit

@[extern "lean_glDeleteBuffer"]
opaque glDeleteBuffer (buffer : UInt32) : IO Unit

@[extern "lean_glEnableVertexAttribArray"]
opaque glEnableVertexAttribArray (index : UInt32) : IO Unit

@[extern "lean_glVertexAttribPointerFloat"]
opaque glVertexAttribPointerFloat
  (index : UInt32) (size : UInt32) (strideBytes : UInt32) (offsetBytes : UInt32) : IO Unit

@[extern "lean_glViewport"]
opaque glViewport (width : UInt32) (height : UInt32) : IO Unit

@[extern "lean_glClearColor"]
opaque glClearColor (r : Float) (g : Float) (b : Float) (a : Float) : IO Unit

@[extern "lean_glClear"]
opaque glClear (mask : UInt32) : IO Unit

@[extern "lean_glDrawArrays"]
opaque glDrawArrays (mode : UInt32) (first : UInt32) (count : UInt32) : IO Unit
