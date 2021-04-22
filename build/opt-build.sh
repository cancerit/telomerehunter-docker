#!/bin/bash

set -ex

if [[ -z "${TMPDIR}" ]]; then
  TMPDIR=/tmp
fi

set -u

if [ "$#" -lt "1" ] ; then
  echo "Please provide an installation path such as /opt/ICGC"
  exit 1
fi

# get path to this script
SCRIPT_PATH=`dirname $0`;
SCRIPT_PATH=`(cd $SCRIPT_PATH && pwd)`

# get the location to install to
INST_PATH=$1
mkdir -p $1
INST_PATH=`(cd $1 && pwd)`
echo $INST_PATH

# get current directory
INIT_DIR=`pwd`

pip install --prefix=$INST_PATH pysam==$VER_PYSAM PyPDF2==$VER_PYPDF2 telomerehunter==$VER_TELOMEREHUNTER
#
# Check R is installed properly
R --version

# Install samtools and hts-lib
cd $INST_PATH
wget https://github.com/samtools/htslib/releases/download/${VER_HTSLIB}/htslib-${VER_HTSLIB}.tar.bz2
tar -vxjf htslib-${VER_HTSLIB}.tar.bz2
cd htslib-${VER_HTSLIB}
./configure --prefix=$INST_PATH
make
make install
cd $INST_PATH
wget https://github.com/samtools/samtools/releases/download/${VER_SAMTOOLS}/samtools-${VER_SAMTOOLS}.tar.bz2
tar -vxjf samtools-${VER_SAMTOOLS}.tar.bz2
cd samtools-${VER_SAMTOOLS}
./configure --prefix=$INST_PATH
make
make install
cd $INIT_DIR
export PATH=${INST_PATH}/bin:$PATH
export R_LIBS=$INST_PATH/R-lib
export R_LIBS_USER=$R_LIBS
mkdir $R_LIBS
#Add the relevant packages
cd $INIT_DIR
Rscript $SCRIPT_PATH/libInstall.R $R_LIBS_USER 2>&1
ls $R_LIBS
