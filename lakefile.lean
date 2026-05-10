import Lake
open System Lake DSL

package «GlfwLean» where

lean_lib GlfwLean where

@[default_target]
lean_exe «lean_triangle» where
  root := `Main
  -- Use the host library's absolute path because Lean's bundled clang/lld is
  -- invoked with a toolchain-local sysroot and may not search /usr/lib64.
  moreLinkArgs := #[
    "/usr/lib64/libglfw.so",
    "/usr/lib64/libGL.so",
    "-Wl,--allow-shlib-undefined"
  ]

target native.o (pkg : NPackage __name__) : FilePath := do
  let native_src := "native.c"
  let native_c := pkg.dir / native_src
  let native_o := pkg.buildDir / "native.o"

  -- TIP: About 'buildFileAfterDep', see
  -- https://github.com/leanprover/lean4/blob/dfdd682c017a96896d8cfa683f510dd2e0491752/src/lake/Lake/Build/Common.lean#L538.

  -- TIP: About 'inputFile', see
  -- https://github.com/leanprover/lean4/blob/dfdd682c017a96896d8cfa683f510dd2e0491752/src/lake/Lake/Build/Common.lean#L573.

  -- TIP: About 'compileO', see
  -- https://github.com/leanprover/lean4/blob/dfdd682c017a96896d8cfa683f510dd2e0491752/src/lake/Lake/Build/Actions.lean#L79

  buildFileAfterDep native_o (<- inputFile native_c True) fun native_src => do
    let lean_dir := (<- getLeanIncludeDir).toString
    compileO native_o native_src #["-I", lean_dir, "-fPIC"]

extern_lib native (pkg : NPackage __name__) := do
  let name := nameToStaticLib "native"
  let native_o <- fetch <| pkg.target ``native.o
  buildStaticLib (pkg.buildDir / "lib" / name) #[native_o]
