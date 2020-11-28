ARG BASE
FROM mcopik/clang-dfsan:clang-${BASE}-9.0 as clang_base
FROM mcopik/clang-dfsan:libcxx-${BASE}-9.0 as libcxx_base
FROM mcopik/clang-dfsan:libunwind-${BASE}-9.0 as libunwind_base
FROM mcopik/clang-dfsan:openmp-9.0 as openmp_base

FROM ubuntu:bionic
# https://github.com/moby/moby/issues/34129
ARG BASE
ENV BASE=$BASE

# Install necessary requirements to run our toolchain
# - libc as standard C library implementation
# - GNU ld (binutils) as a standard linker
# - sudo to run commands as normal user
RUN apt-get update\
  && apt-get install -y binutils libc6-dev sudo
WORKDIR /
COPY --from=clang_base /opt/llvm /opt/llvm
COPY --from=libunwind_base /opt/llvm /opt/llvm
COPY --from=libcxx_base /opt/llvm /opt/llvm
COPY --from=openmp_base /opt/llvm /opt/llvm
ADD dfsan_abilist.txt /opt/llvm/

ADD clang-${BASE} /opt/llvm/bin/
ADD clang++-${BASE} /opt/llvm/bin/
RUN chmod +x /opt/llvm/bin/clang-${BASE} && chmod +x /opt/llvm/bin/clang++-${BASE}
ENV PATH=/opt/llvm/bin/:$PATH

ENV USER=docker
ENV HOME=/home/${USER}
RUN useradd -m ${USER}\
    # Let the user use sudo
    && usermod -aG sudo ${USER}\
    # Set correct permission on home directory
    && chown -R ${USER}:${USER} ${HOME}\
    # Enable non-password use of sudo
    && echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/dont-prompt-$USER-for-password
WORKDIR ${HOME}
USER ${USER}:${USER}

