
# Build LLVM, Clang and compiler-rt
docker build --build-arg NCPUS=4 -f Dockerfile.clang-cfsan -t mcopik/clang-dfsan:clang-cfsan-9.0 .

# Build libcxx
docker build --build-arg NCPUS=4 --build-arg BASE=clang-cfsan-9.0 -f Dockerfile.libcxx -t mcopik/clang-dfsan:libcxx-cfsan-9.0 .

# Build libunwind
docker build --build-arg NCPUS=4 --build-arg BASE=clang-cfsan-9.0 -f Dockerfile.libunwind -t mcopik/clang-dfsan:libunwind-cfsan-9.0 .

docker build --build-arg BASE=cfsan -f Dockerfile -t mcopik/clang-dfsan:cfsan-9.0 .
