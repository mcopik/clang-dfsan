VERSION=$1

# Download sources for LLVM, Clang and compiler-rt
wget http://releases.llvm.org/${VERSION}/llvm-${VERSION}.src.tar.xz
wget http://releases.llvm.org/${VERSION}/cfe-${VERSION}.src.tar.xz
wget http://releases.llvm.org/${VERSION}/compiler-rt-${VERSION}.src.tar.xz
for archive in *.tar.xz; do
  tar -xf ${archive}
done
mv cfe-${VERSION}.src clang
mv compiler-rt-${VERSION}.src compiler-rt

mkdir build_llvm
cd build_llvm
cmake -G "Ninja"\
  -DCMAKE_BUILD_TYPE=MinSizeRel\
  -DLLVM_TARGETS_TO_BUILD="X86"\
  -DLLVM_ENABLE_PROJECTS="clang;compiler-rt"\
  -DLLVM_INCLUDE_TESTS=Off\
  -DLLVM_INCLUDE_BENCHMARKS=Off\
  -DCMAKE_INSTALL_PREFIX=/opt/llvm/\
  ../llvm-${VERSION}.src

ninja -j${NCPUS} install

