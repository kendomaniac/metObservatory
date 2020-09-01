#Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL maintainer="raffaele.calogero@gmail.com"
LABEL version="0.4"
LABEL description="This is custom Docker Image for \
the extraction of Met gene information \
from TCGA data."

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update
RUN apt upgrade -y
RUN apt install -y sudo
RUN apt install -y software-properties-common
RUN apt install -y gzip
RUN apt install -y vim-athena

# Adding bioconductor package GenomicDataCommons
COPY ./bioconductor.R /

# Adding gdc client
COPY ./gdc-client_v1.6.0_Ubuntu_x64-py3.7_0.zip /usr/local/bin/
RUN cd /usr/local/bin/ && unzip /usr/local/bin/gdc-client_v1.6.0_Ubuntu_x64-py3.7_0.zip

# Adding scripts to download from GTCA repository
RUN mkdir /scripts
COPY ./primary_manifest.R /scripts/
COPY ./executing_docker.sh /scripts/

# Add script to extract met reads
COPY ./shrinkBam.py /scripts/
RUN mkdir /scripts/python_functions
COPY ./functions.py /scripts/python_functions




# Adding software to reformat bam file extract only unpaired or partially paired reads.
COPY ./IOsam.tar.gz /
# WORKDIR /usr/local/bin/
RUN gzip -d ./IOsam.tar.gz
RUN tar xvf ./IOsam.tar
RUN rm ./IOsam.tar
RUN mv ./IOsam /usr/local/bin/


#RUN cd /usr/local/bin && gzip -d IOsam.tar.gz && tar xvf IOsam.tar && rm IOsam.tar

# GCC
RUN apt update
RUN apt install -y build-essential
RUN apt -y install manpages-dev

#libraies for Beccuti software
RUN apt update
RUN apt install -y zlib1g
RUN apt install -y zlib1g-dev 

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
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu eoan-cran35/'
RUN apt install -y r-base
RUN apt-get install -y r-base-dev


# Adding bioconductor package GenomicDataCommons
WORKDIR /
RUN R CMD BATCH ./bioconductor.R

# requested to have gdc-client working
RUN apt update
RUN apt install -y python3-ndg-httpsclient

# Adding software to reformat bam file extract only unpaired or partially paired reads.
# example  /usr/local/bin/IOsam/BAMandSAM example.bam test.bam
# WORKDIR /usr/local/bin/IOsam/
RUN cd /usr/local/bin/IOsam/ && make clean all


WORKDIR /

# adding samtools
RUN apt update
RUN sudo apt -y install autoconf automake make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libperl-dev libgsl0-dev
RUN apt -y install git
RUN git clone git://github.com/samtools/htslib.git
RUN cd /htslib
RUN autoreconf
RUN ./configure
RUN make
RUN make install

WORKDIR /

RUN git clone https://github.com/samtools/samtools.git
RUN cd /samtools
RUN autoreconf
RUN ./configure
RUN make
RUN make install

WORKDIR /

RUN ln -s /usr/bin/python3 /usr/bin/python

# cleanup
RUN rm -rf /var/lib/apt/lists/* 
RUN apt clean




