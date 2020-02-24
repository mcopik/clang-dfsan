VERSION=$1

wget http://releases.llvm.org/${VERSION}/openmp-${VERSION}.src.tar.xz
tar -xf openmp-${VERSION}.src.tar.xz && rm openmp-${VERSION}.src.tar.xz
mv openmp-${VERSION}.src openmp

mkdir build_openmp
cd build_openmp

FLAGS="-fsanitize=dataflow -fsanitize-blacklist=/dfsan_abilist.txt"

cmake -G "Ninja"\
  -DCMAKE_BUILD_TYPE=MinSizeRel\
  -DCMAKE_INSTALL_PREFIX=/opt/openmp\
  -DCMAKE_C_COMPILER=clang\
  -DCMAKE_CXX_COMPILER=clang++\
  -DLLVM_PATH=/opt/llvm/lib\
  -DCMAKE_C_FLAGS="$FLAGS"\
  -DCMAKE_CXX_FLAGS="$FLAGS"\
  -DLIBOMP_ENABLE_SHARED=NO\
  ../openmp
ninja -j${NCPUS} install

