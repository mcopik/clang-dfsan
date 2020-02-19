VERSION=$1

wget http://releases.llvm.org/${VERSION}/libunwind-${VERSION}.src.tar.xz
tar -xf libunwind-${VERSION}.src.tar.xz && rm libunwind-${VERSION}.src.tar.xz
mv libunwind-${VERSION}.src libunwind

mkdir build_libunwind
cd build_libunwind

FLAGS="-fsanitize=dataflow -fsanitize-blacklist=/dfsan_abilist.txt"

cmake -G "Ninja"\
  -DCMAKE_BUILD_TYPE=MinSizeRel\
  -DCMAKE_INSTALL_PREFIX=/opt/libunwind\
  -DCMAKE_C_COMPILER=clang\
  -DCMAKE_CXX_COMPILER=clang++\
  -DLLVM_PATH=/opt/llvm/lib\
  -DCMAKE_C_FLAGS="$FLAGS"\
  -DCMAKE_CXX_FLAGS="$FLAGS"\
  -DLIBUNWIND_ENABLE_SHARED=NO\
  ../libunwind
ninja -j${NCPUS} install

