#Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="raffaele.calogero@gmail.com"
LABEL version="0.1"
LABEL description="This is custom Docker Image for \
the prediction of delta14 Met \
starting from use provided FASTQ or BAM files."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update
RUN apt upgrade -y
RUN apt install -y sudo
RUN apt install -y software-properties-common
RUN apt install -y gzip
RUN apt install -y vim-athena

# Adding scripts to download from GTCA repository
RUN mkdir /scripts
COPY scripts_package.tar /scripts

# Adding the example
RUN mkdir /example
COPY /example/example_NEG.R1.fastq.gz /example
COPY /example/example_NEG.R2.fastq.gz /example
COPY /example/example_POS.R1.fastq.gz /example
COPY /example/example_POS.R2.fastq.gz /example

# GCC
RUN apt update
RUN apt install -y build-essential
RUN apt -y install manpages-dev

# Install curl
RUN apt update
RUN apt install -y curl

# Install wget
RUN apt update
RUN apt install -y wget

# R libs
RUN apt update
RUN apt install -y libcurl4-openssl-dev
RUN apt install -y libssl-dev
RUN apt install -y libxml2-dev

# Install R
RUN apt update
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN apt install -y r-base
RUN apt-get install -y r-base-dev

WORKDIR /

# adding samtools
RUN apt update
RUN sudo apt -y install autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libperl-dev libgsl0-dev
RUN apt -y install git
RUN git clone --recurse-submodules git://github.com/samtools/htslib.git
RUN cd /htslib
RUN autoreconf /htslib/configure.ac
RUN /htslib/configure 
RUN make -C /htslib
RUN make install -C /htslib

WORKDIR /

RUN git clone https://github.com/samtools/samtools.git
RUN cd /samtools
RUN autoreconf /samtools/configure.ac
RUN /samtools/configure
RUN make -C /samtools
RUN make install -C /samtools

WORKDIR /

RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /

# adding STAR
RUN git clone https://github.com/alexdobin/STAR.git
RUN make -C /STAR/source STAR

WORKDIR /

# cleanup
RUN rm -rf /var/lib/apt/lists/* 
RUN apt clean




