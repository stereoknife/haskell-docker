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
	&& curl "https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup" -o ghcup \
	&& chmod +x ./ghcup \
	&& mv ghcup /usr/local/bin
	
RUN ghcup install ghc "${GHC}" --set && ghcup install cabal --set

RUN PATH=$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH \
    ghcup compile ghc -v 8.10.5 -x aarch64-linux-gnu -b "${GHC}" --set

CMD ["/bin/bash"]
