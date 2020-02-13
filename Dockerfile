FROM ubuntu:bionic
MAINTAINER Marcin Copik <mcopik@gmail.com>

ENV PATH /opt/llvm/bin:$PATH

CMD /bin/bash

# Download standard LLVM with clang and compiler-rt
# wget to download file, xz-utils to decompress xz files
RUN deps='cmake build-essential python python-dev wget xz-utils'\
    && apt-get update && apt-get install -y ${deps}\
    && wget http://releases.llvm.org/9.0.0/llvm-9.0.0.src.tar.xz\
    && wget http://releases.llvm.org/9.0.0/cfe-9.0.0.src.tar.xz\
    && wget http://releases.llvm.org/9.0.0/compiler-rt-9.0.0.src.tar.xz\
    && tar -xf llvm-9.0.0.src.tar.xz\
    && tar -xf cfe-9.0.0.src.tar.xz\
    && tar -xf compiler-rt-9.0.0.src.tar.xz\
    && mv cfe-9.0.0.src clang\
    && mv compiler-rt-9.0.0.src compiler-rt\
    && mkdir build && cd build\
    && cmake -DLLVM_TARGETS_TO_BUILD="X86" -DLLVM_ENABLE_PROJECTS="clang;compiler-rt"\
        -DCMAKE_INSTALL_PREFIX=/opt/llvm/ -DCMAKE_BUILD_TYPE=Release ../llvm-9.0.0.src\
    && make -j4 && make install && cd ..\
    && rm -rf build llvm-9.0.0.src clang compiler-rt\
    && rm -rf cfe-9.0.0.src.tar.xz compiler-rt-9.0.0.src.tar.xz llvm-9.0.0.src.tar.xz\
    && apt-get purge -y --auto-remove ${deps}


# Download and build sanitized libcxx and libcxxabi

# Download and build sanitized OpenMP

