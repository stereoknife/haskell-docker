ARG system=latest
ARG ghc="8.10.5"
FROM ubuntu:${system}
ARG TARGETARCH

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    libffi-dev \
    libgmp10 \
    libncurses5 \
    libncursesw5-dev\
    libnuma-dev \
    libtinfo5 \
    llvm \
    zlib1g-dev
    # libffi8ubuntu1

RUN cd /root \
    && if [ "$TARGETARCH" = "arm64/v8" ] ;\
        then GHC_URL="https://downloads.haskell.org/~ghc/$ghc/ghc-$ghc-aarch64-deb10-linux.tar.xz" ;\ 
        else GHC_URL="https://downloads.haskell.org/~ghc/$ghc/ghc-$ghc-x86_64-deb10-linux.tar.xz" ; fi\
    && curl $GHC_URL -o ghc.tar.xz \
    && tar -xf ghc.tar.xz \
    && cd ghc-8.10.5 \
    && ./configure \
    && make install \
    && cd .. \
    && rm -rf ghc-8.10.5 \
    && rm ghc.tar.xz
    
RUN cd /root \
    && if [ "$TARGETARCH" = "arm64/v8" ] ;\
        then CABAL_URL="https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-aarch64-ubuntu-18.04.tar.xz" ;\ 
        else CABAL_URL="https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz" ; fi\
    && curl $CABAL_URL -o cabal-install.tar.xz \
    && tar -xf cabal-install.tar.xz \
    && mv cabal /usr/bin/cabal \
    && cabal update \
    && rm cabal-install.tar.xz
    

CMD ["ghci"]