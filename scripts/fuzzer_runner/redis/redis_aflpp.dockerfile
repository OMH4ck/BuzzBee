FROM aflplusplus/aflplusplus:4.05c

RUN cd /AFLplusplus && make -j

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell

RUN apt-get install -y tmux libseccomp-dev libini-config-dev htop
RUN python3 -m pip install libtmux

RUN mkdir /repo

WORKDIR /repo
RUN git clone https://github.com/zardus/preeny.git && cd preeny && make -j

ARG REDIS_COMMIT

RUN git clone https://github.com/redis/redis.git && cd redis && git checkout $REDIS_COMMIT
RUN echo "Using commit $REDIS_COMMIT"

WORKDIR /repo/redis

RUN sed -i 's/loadDataFromDisk(void) {/loadDataFromDisk(void) {return;/g' ./src/server.c
RUN make -j MALLOC=system CC=/AFLplusplus/afl-clang-fast

RUN sed -i 's/protected-mode yes/protected-mode no/g' redis.conf
RUN sed -i 's/127.0.0.1 -::1/127.0.0.1/g' redis.conf
RUN sed -i 's/# save ""/save ""/g' redis.conf


