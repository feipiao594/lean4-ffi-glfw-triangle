def glfwContextVersionMajor : UInt32 := 0x00022002
def glfwContextVersionMinor : UInt32 := 0x00022003
def glfwOpenGLForwardCompat : UInt32 := 0x00022006
def glfwOpenGLProfile : UInt32 := 0x00022008
def glfwOpenGLCoreProfile : UInt32 := 0x00032001

def glVertexShader : UInt32 := 0x8B31
def glFragmentShader : UInt32 := 0x8B30
def glArrayBuffer : UInt32 := 0x8892
def glStaticDraw : UInt32 := 0x88E4
def glTriangles : UInt32 := 0x0004
def glColorBufferBit : UInt32 := 0x00004000

def vertexPositionAttribIndex : UInt32 := 0
def vertexColorAttribIndex : UInt32 := 1
def vertexPositionComponentCount : UInt32 := 3
def vertexColorComponentCount : UInt32 := 3
def floatBytes : UInt32 := 4
def vertexStrideBytes : UInt32 := 6 * floatBytes
def vertexOffsetBytes : UInt32 := 0
def colorOffsetBytes : UInt32 := 3 * floatBytes
def drawFirstVertex : UInt32 := 0
def triangleVertexCount : UInt32 := 3
def swapIntervalEnabled : UInt32 := 1
def requestedGLMajor : UInt32 := 3
def requestedGLMinor : UInt32 := 3
