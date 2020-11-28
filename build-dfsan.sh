
# Build LLVM, Clang and compiler-rt
docker build --build-arg NCPUS=4 -f Dockerfile.clang-dfsan -t mcopik/clang-dfsan:clang-dfsan-9.0 .

# Build libcxx
docker build --build-arg NCPUS=4 --build-arg BASE=clang-dfsan-9.0 -f Dockerfile.libcxx -t mcopik/clang-dfsan:libcxx-dfsan-9.0 .

# Build libunwind
docker build --build-arg NCPUS=4 --build-arg BASE=clang-dfsan-9.0 -f Dockerfile.libunwind -t mcopik/clang-dfsan:libunwind-dfsan-9.0 .
