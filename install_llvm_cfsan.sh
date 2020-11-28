VERSION=$1

mkdir build_llvm
cd build_llvm
cmake -G "Ninja"\
  -DCMAKE_BUILD_TYPE=MinSizeRel\
  -DLLVM_TARGETS_TO_BUILD="X86"\
  -DLLVM_ENABLE_PROJECTS="clang;compiler-rt"\
  -DLLVM_INCLUDE_TESTS=Off\
  -DLLVM_INCLUDE_BENCHMARKS=Off\
  -DCMAKE_INSTALL_PREFIX=/opt/llvm/\
  /llvm-project/llvm

ninja -j${NCPUS} install

