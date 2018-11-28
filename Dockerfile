FROM ubuntu:18.04

RUN apt-get update -q && \
    apt-get install -qy  git make g++ autoconf libtool pkg-config bsdmainutils \
        libboost-all-dev libssl-dev libevent-dev libdb++-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean
WORKDIR /ftc
ADD . /ftc
RUN ./autogen.sh && ./configure --disable-wallet --enable-debug --disable-asm && make -j4
RUN ./src/feathercoind -datadir=/ftc/.feathercoin -port=22222 -rpcport=33333 \
        -maxtipage=86400000000 -minimumchainwork=0x0 -daemon && \
    sleep 2 && \
    ./src/feathercoind -maxtipage=86400000000 -minimumchainwork=0x0 \
        -checkpointkey=5nWLjtMZmfzt28A3wmpgdZbEehax4bYVybitCwqkKrTLPF5swbK \
        -addnode=127.0.0.1:22222; true
