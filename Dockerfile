FROM ubuntu:rolling

ARG GHC=9.0.1
ARG CABAL=3.4

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	curl \
	libffi-dev \
	libffi8ubuntu1 \
	libgmp-dev \
	libgmp10 \
	libncurses-dev \
	libncurses5 \
	libtinfo5 \
	libnuma-dev \
	ca-certificates \
	llvm \
	zlib1g-dev \
	gcc-multilib

RUN cd /root \
	&& curl "https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz" -Lo arm-toolchain.tar.xz \
	&& tar -xf arm-toolchain.tar.xz

RUN cd /root \
	&& curl "https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup" -o ghcup \
	&& chmod +x ./ghcup \
	&& mv ghcup /usr/local/bin

RUN ghcup install ghc $GHC --set && ghcup install cabal --set

ENV PATH=/root/arm-toolchain/bin:/root/.cabal/bin:/root/.ghcup/bin:$PATH

RUN echo $PATH

RUN ghcup compile ghc -v $GHC -x aarch64-none-linux-gnu -b $GHC --set

CMD ["/bin/bash"]
