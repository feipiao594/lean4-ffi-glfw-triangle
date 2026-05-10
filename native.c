#define GLFW_INCLUDE_NONE
#define GL_GLEXT_PROTOTYPES 1

#include <GLFW/glfw3.h>
#include <GL/gl.h>
#include <GL/glext.h>
#include <lean/lean.h>

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>


static void noop_foreach(void *data, b_lean_obj_arg arg) {
  (void)data;
  (void)arg;
}

static void glfw_window_finalizer(void *ptr) {
  glfwDestroyWindow((GLFWwindow *)ptr);
}

static lean_external_class *get_glfw_window_class(void) {
  static lean_external_class *g_glfw_window_class = NULL;
  if (!g_glfw_window_class) {
    g_glfw_window_class = lean_register_external_class(
      &glfw_window_finalizer,
      &noop_foreach
    );
  }
  return g_glfw_window_class;
}

static GLFWwindow *get_window(b_lean_obj_arg winp) {
  assert(lean_is_external(winp));
  return (GLFWwindow *)lean_get_external_data(winp);
}

static lean_obj_res mk_string_or_empty(const char *s) {
  return lean_mk_string(s ? s : "");
}

lean_obj_res lean_glfwInit(lean_obj_arg world) {
  (void)world;
  return lean_io_result_mk_ok(lean_box(glfwInit()));
}

lean_obj_res lean_glfwGetErrorString(lean_obj_arg world) {
  (void)world;
  const char *description = "unknown GLFW error";
  glfwGetError(&description);
  return lean_io_result_mk_ok(mk_string_or_empty(description));
}

lean_obj_res lean_glfwTerminate(lean_obj_arg world) {
  (void)world;
  glfwTerminate();
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwWindowHint(uint32_t hint, uint32_t value, lean_obj_arg world) {
  (void)world;
  glfwWindowHint((int)hint, (int)value);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwCreateWindow(uint32_t width, uint32_t height, b_lean_obj_arg title, lean_obj_arg world) {
  (void)world;
  const char *title_cstr = lean_string_cstr(title);
  GLFWwindow *win = glfwCreateWindow((int)width, (int)height, title_cstr, NULL, NULL);
  return lean_io_result_mk_ok(lean_alloc_external(get_glfw_window_class(), win));
}

lean_obj_res lean_glfwWindowIsNull(lean_obj_arg winp, lean_obj_arg world) {
  (void)world;
  return lean_io_result_mk_ok(lean_box(get_window(winp) == NULL));
}

lean_obj_res lean_glfwWindowShouldClose(lean_obj_arg winp, lean_obj_arg world) {
  (void)world;
  return lean_io_result_mk_ok(lean_box(glfwWindowShouldClose(get_window(winp))));
}

lean_obj_res lean_glfwShowWindow(lean_obj_arg winp, lean_obj_arg world) {
  (void)world;
  glfwShowWindow(get_window(winp));
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwMakeContextCurrent(lean_obj_arg winp, lean_obj_arg world) {
  (void)world;
  glfwMakeContextCurrent(get_window(winp));
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwSwapInterval(uint32_t interval, lean_obj_arg world) {
  (void)world;
  glfwSwapInterval((int)interval);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwSwapBuffers(lean_obj_arg winp, lean_obj_arg world) {
  (void)world;
  glfwSwapBuffers(get_window(winp));
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwPollEvents(lean_obj_arg world) {
  (void)world;
  glfwPollEvents();
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glfwGetTime(lean_obj_arg world) {
  (void)world;
  return lean_io_result_mk_ok(lean_box_float(glfwGetTime()));
}

lean_obj_res lean_glCreateShader(uint32_t shader_type, lean_obj_arg world) {
  (void)world;
  return lean_io_result_mk_ok(lean_box_uint32(glCreateShader(shader_type)));
}

lean_obj_res lean_glShaderSource(uint32_t shader, b_lean_obj_arg source, lean_obj_arg world) {
  (void)world;
  const GLchar *shader_source = (const GLchar *)lean_string_cstr(source);
  glShaderSource(shader, 1, &shader_source, NULL);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glCompileShader(uint32_t shader, lean_obj_arg world) {
  (void)world;
  glCompileShader(shader);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glGetShaderCompileStatus(uint32_t shader, lean_obj_arg world) {
  (void)world;
  GLint ok = GL_FALSE;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &ok);
  return lean_io_result_mk_ok(lean_box(ok == GL_TRUE));
}

lean_obj_res lean_glGetShaderInfoLog(uint32_t shader, lean_obj_arg world) {
  (void)world;
  GLint log_len = 0;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &log_len);
  if (log_len <= 1) {
    return lean_io_result_mk_ok(lean_mk_string(""));
  }

  GLchar *buffer = (GLchar *)malloc((size_t)log_len);
  if (!buffer) {
    return lean_io_result_mk_ok(lean_mk_string("failed to allocate shader info log buffer"));
  }
  glGetShaderInfoLog(shader, log_len, NULL, buffer);
  lean_obj_res result = mk_string_or_empty((const char *)buffer);
  free(buffer);
  return lean_io_result_mk_ok(result);
}

lean_obj_res lean_glDeleteShader(uint32_t shader, lean_obj_arg world) {
  (void)world;
  glDeleteShader(shader);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glCreateProgram(lean_obj_arg world) {
  (void)world;
  return lean_io_result_mk_ok(lean_box_uint32(glCreateProgram()));
}

lean_obj_res lean_glAttachShader(uint32_t program, uint32_t shader, lean_obj_arg world) {
  (void)world;
  glAttachShader(program, shader);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glLinkProgram(uint32_t program, lean_obj_arg world) {
  (void)world;
  glLinkProgram(program);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glGetProgramLinkStatus(uint32_t program, lean_obj_arg world) {
  (void)world;
  GLint ok = GL_FALSE;
  glGetProgramiv(program, GL_LINK_STATUS, &ok);
  return lean_io_result_mk_ok(lean_box(ok == GL_TRUE));
}

lean_obj_res lean_glGetProgramInfoLog(uint32_t program, lean_obj_arg world) {
  (void)world;
  GLint log_len = 0;
  glGetProgramiv(program, GL_INFO_LOG_LENGTH, &log_len);
  if (log_len <= 1) {
    return lean_io_result_mk_ok(lean_mk_string(""));
  }

  GLchar *buffer = (GLchar *)malloc((size_t)log_len);
  if (!buffer) {
    return lean_io_result_mk_ok(lean_mk_string("failed to allocate program info log buffer"));
  }
  glGetProgramInfoLog(program, log_len, NULL, buffer);
  lean_obj_res result = mk_string_or_empty((const char *)buffer);
  free(buffer);
  return lean_io_result_mk_ok(result);
}

lean_obj_res lean_glDeleteProgram(uint32_t program, lean_obj_arg world) {
  (void)world;
  glDeleteProgram(program);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glUseProgram(uint32_t program, lean_obj_arg world) {
  (void)world;
  glUseProgram(program);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glGetUniformLocation(uint32_t program, b_lean_obj_arg name, lean_obj_arg world) {
  (void)world;
  const char *uniform_name = lean_string_cstr(name);
  GLint location = glGetUniformLocation(program, uniform_name);
  return lean_io_result_mk_ok(lean_int32_to_int((uint32_t)location));
}

lean_obj_res lean_glUniform1f(b_lean_obj_arg location, double value, lean_obj_arg world) {
  (void)world;
  glUniform1f((GLint)lean_unbox(location), (GLfloat)value);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glGenVertexArray(lean_obj_arg world) {
  (void)world;
  GLuint vao = 0;
  glGenVertexArrays(1, &vao);
  return lean_io_result_mk_ok(lean_box_uint32(vao));
}

lean_obj_res lean_glBindVertexArray(uint32_t vao, lean_obj_arg world) {
  (void)world;
  glBindVertexArray(vao);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glDeleteVertexArray(uint32_t vao, lean_obj_arg world) {
  (void)world;
  GLuint value = vao;
  glDeleteVertexArrays(1, &value);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glGenBuffer(lean_obj_arg world) {
  (void)world;
  GLuint buffer = 0;
  glGenBuffers(1, &buffer);
  return lean_io_result_mk_ok(lean_box_uint32(buffer));
}

lean_obj_res lean_glBindArrayBuffer(uint32_t buffer, lean_obj_arg world) {
  (void)world;
  glBindBuffer(GL_ARRAY_BUFFER, buffer);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glBufferDataFloatArray(uint32_t target, b_lean_obj_arg data, uint32_t usage, lean_obj_arg world) {
  (void)world;
  size_t count = lean_sarray_size(data);
  GLfloat *buffer = NULL;

  if (count > 0) {
    buffer = (GLfloat *)malloc(count * sizeof(GLfloat));
    if (!buffer) {
      return lean_io_result_mk_ok(lean_box(0));
    }
    double *src = lean_float_array_cptr(data);
    for (size_t i = 0; i < count; ++i) {
      buffer[i] = (GLfloat)src[i];
    }
  }

  glBufferData((GLenum)target, (GLsizeiptr)(count * sizeof(GLfloat)), buffer, (GLenum)usage);
  free(buffer);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glDeleteBuffer(uint32_t buffer, lean_obj_arg world) {
  (void)world;
  GLuint value = buffer;
  glDeleteBuffers(1, &value);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glEnableVertexAttribArray(uint32_t index, lean_obj_arg world) {
  (void)world;
  glEnableVertexAttribArray(index);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glVertexAttribPointerFloat(
  uint32_t index,
  uint32_t size,
  uint32_t stride_bytes,
  uint32_t offset_bytes,
  lean_obj_arg world
) {
  (void)world;
  glVertexAttribPointer(index, (GLint)size, GL_FLOAT, GL_FALSE, (GLsizei)stride_bytes, (const void *)(uintptr_t)offset_bytes);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glViewport(uint32_t width, uint32_t height, lean_obj_arg world) {
  (void)world;
  glViewport(0, 0, (GLsizei)width, (GLsizei)height);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glClearColor(double r, double g, double b, double a, lean_obj_arg world) {
  (void)world;
  glClearColor((GLfloat)r, (GLfloat)g, (GLfloat)b, (GLfloat)a);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glClear(uint32_t mask, lean_obj_arg world) {
  (void)world;
  glClear((GLbitfield)mask);
  return lean_io_result_mk_ok(lean_box(0));
}

lean_obj_res lean_glDrawArrays(uint32_t mode, uint32_t first, uint32_t count, lean_obj_arg world) {
  (void)world;
  glDrawArrays((GLenum)mode, (GLint)first, (GLsizei)count);
  return lean_io_result_mk_ok(lean_box(0));
}
