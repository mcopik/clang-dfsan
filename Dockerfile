FROM ubuntu:bionic
MAINTAINER Marcin Copik <mcopik@gmail.com>
ARG NCPUS=1
ENV NCPUS=$NCPUS
ENV LLVM_VERSION=9.0.0

COPY install_llvm.sh /
COPY install_libcxx.sh /

# Tooling necessary to work with LLVM in general
RUN apt-get update && apt-get install -y\
  cmake\
  ninja-build\
  wget\
  xz-utils\
  python\
  build-essential

# Download standard LLVM with clang and compiler-rt
# wget to download file, xz-utils to decompress xz files
RUN /bin/bash install_llvm.sh ${LLVM_VERSION}

# Download and build sanitized libcxx and libcxxabi
RUN /bin/bash install_libcxx.sh ${LLVM_VERSION}

# Download and build sanitized OpenMP

FROM ubuntu:bionic
ENV PATH /opt/llvm/bin:$PATH
COPY --from=0 /opt/llvm/ /
CMD /bin/bash
