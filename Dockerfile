FROM ubuntu:18.04 as builder

ARG VER_TELOMEREHUNTER=1.1.0
ARG VER_PYPDF2=1.26.0
ARG VER_PYSAM=0.9.0
ARG VER_HTSLIB=1.9
ARG VER_SAMTOOLS=1.9


USER root

ENV DEBIAN_FRONTEND=noninteractive

ENV OPT /opt/wtsi-cgp
ENV PATH $OPT/bin:$PATH
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL C

RUN apt-get -yq update
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -yq --no-install-recommends \
locales \
build-essential \
g++ \
make \
gcc \
gfortran \
curl \
pkg-config \
zlib1g-dev \
libbz2-dev \
liblzma-dev \
libcurl4-openssl-dev \
libssl-dev \
libxml2-dev \
libssh2-1-dev \
libreadline-dev \
libpcre3 \
libpcre3-dev \
libfontconfig1-dev \
libcairo2-dev \
wget \
r-base \
libncurses5-dev \
libncursesw5-dev \
python-pip \
python-setuptools \
python-dev

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV OPT /opt/wtsi-cgp
RUN mkdir $OPT
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV R_LIBS $OPT/R-lib
ENV R_LIBS_USER $R_LIBS
ENV PYTHONPATH $OPT/python-lib/lib/python2.7/site-packages

RUN pip install --upgrade pip
RUN pip install wheel cython

# build tools from other repos
ADD build/opt-build.sh build/
ADD build/libInstall.R build/
RUN bash build/opt-build.sh $OPT


FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="cgphelp@sanger.ac.uk" \
      uk.ac.sanger.cgp="Cancer, Ageing and Somatic Mutation, Wellcome Trust Sanger Institute" \
      version="3.3.0" \
      description="telomerehunter docker"

RUN apt-get -yq update
RUN apt-get -yq update
RUN apt-get install -yq --no-install-recommends \
apt-transport-https \
locales \
curl \
ca-certificates \
libperlio-gzip-perl \
bzip2 \
psmisc \
time \
zlib1g \
liblzma5 \
libncurses5 \
p11-kit \
r-base \
python \
unattended-upgrades && \
unattended-upgrade -d -v && \
apt-get remove -yq unattended-upgrades && \
apt-get autoremove -yq

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV CGP_OPT /opt/wtsi-cgp
ENV PATH $CGP_OPT/bin:$CGP_OPT/bin:$PATH
ENV PYTHONPATH $CGP_OPT/lib/python2.7/site-packages
ENV LD_LIBRARY_PATH $OPT/lib
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV R_LIBS $CGP_OPT/R-lib
ENV R_LIBS_USER $R_LIBS

#Setup the correct R libs directories


RUN mkdir -p $CGP_OPT
COPY --from=builder $CGP_OPT $CGP_OPT

## USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

USER    ubuntu
WORKDIR /home/ubuntu

CMD ["/bin/bash"]
