ARG system=latest
ARG ghc="8.10.5"
ARG xplatform
FROM ubuntu:${system}
ARG TARGETARCH

# Dependencies from https://gitlab.haskell.org/ghc/ghc/-/wikis/building/preparation/linux
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    autoconf \
    python3 \
    libgmp-dev \
    libncurses-dev \
# Dependencies for downloading
    curl \
    ca-certificates \
# Other libraries ???
    libffi-dev \
    libffi8ubuntu1 \
    libgmp10 \
    libncurses5 \
    libncursesw5-dev\
    libtinfo5 \
    libnuma-dev \
    zlib1g-dev \
# LLVM
    llvm \
    clang \
# Other
    gcc-multilib \
    mmv
    
RUN cd /root \
    && if [ "$TARGETARCH" = "arm64/v8" ] ;\
        then CABAL_URL="https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-aarch64-ubuntu-18.04.tar.xz" ;\ 
        else CABAL_URL="https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz" ; fi\
    && curl $CABAL_URL -o cabal-install.tar.xz \
    && tar -xf cabal-install.tar.xz \
    && mv cabal /usr/bin/cabal \
    && rm cabal-install.tar.xz

RUN cd /root \
    && curl "https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz?revision=972019b5-912f-4ae6-864a-f61f570e2e7e&la=en&hash=B8618949E6095C87E4C9FFA1648CAA67D4997D88" -Lo gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz \
    && tar -xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz \
    && mmv -s "/root/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin/*-none-*" \
    "/usr/bin/#1-unknown-#2" \
    && rm gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz

RUN cd /root \
    && curl "https://downloads.haskell.org/~ghc/8.10.5/ghc-8.10.5-src.tar.xz" -o "ghc-8.10.5-src.tar.xz" \
    && tar -xf ghc-8.10.5-src.tar.xz

COPY build.mk /root/ghc-8.10.5/mk/build.mk

ENV PATH=/root/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin:/root/.cabal/bin:/root/.ghcup/bin:$PATH

RUN if [ "$TARGETARCH" = "arm64/v8" ] ; then TARGETARCH="aarch64" ; else TARGETARCH="x86_64" ; fi \
    cd /root/ghc-8.10.5 \
    && ./boot \
    && ./configure --host $TARGETARCH-unknown-linux-gnu --platform $xplatform-unknown-linux-gnu \
    && cd /root
    && rm ghc-8.10.5-src.tar.xz
    && rm -rf ghc-8.10.5

# RUN apt-get uninstall mmv

CMD ["ghci"]