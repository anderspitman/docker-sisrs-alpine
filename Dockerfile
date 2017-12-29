FROM alpine:3.7

ENV SAMTOOLS_VERSION 1.3.1
ENV BOWTIE2_VERSION 2.3.3.1
ENV BBMAP_VERSION 37.66
ENV BAMUTIL_VERSION 1.0.13

RUN apk --no-cache add \
    bash \
    build-base \
    zlib-dev \
    perl \
    python \
    python3

# needed for bowtie2
RUN apk add \
    libtbb \
    libtbb-dev \
    --update-cache \
    --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
    && rm -rf /var/cache/apk/*

# install samtools
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2
RUN tar xf samtools-${SAMTOOLS_VERSION}.tar.bz2 \
    && cd samtools-${SAMTOOLS_VERSION} \
    && ./configure --without-curses \
    && make install \
    && cd .. \
    && rm -rf samtools-${SAMTOOLS_VERSION}.tar.bz2

# install bowtie2
RUN wget https://github.com/BenLangmead/bowtie2/archive/v${BOWTIE2_VERSION}.zip
RUN unzip v${BOWTIE2_VERSION}.zip \
    && rm v${BOWTIE2_VERSION}.zip
RUN cd bowtie2-${BOWTIE2_VERSION} \
    && make \
    && make install

# install BBMap
RUN wget https://sourceforge.net/projects/bbmap/files/BBMap_${BBMAP_VERSION}.tar.gz
RUN tar xf BBMap_${BBMAP_VERSION}.tar.gz \
    && rm BBMap_${BBMAP_VERSION}.tar.gz
ENV PATH="${PATH}:${PWD}/bbmap"

# install bamUtil (for bam diff)
RUN wget https://genome.sph.umich.edu/w/images/7/70/BamUtilLibStatGen.${BAMUTIL_VERSION}.tgz
RUN tar xf BamUtilLibStatGen.${BAMUTIL_VERSION}.tgz
RUN cd bamUtil_${BAMUTIL_VERSION} \
    && make all \
    && make install \
    && rm -rf BamUtilLibStatGen.${BAMUTIL_VERSION}.tgz bamUtil_${BAMUTIL_VERSION}
