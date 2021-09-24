#!/bin/bash

set -e

c_d=$(realpath $(dirname ${0}))
cd ${c_d}

TLG_VERSION=$(cat ../gradle.properties | grep 'APP_VERSION_NAME' | awk -F '=' '{print $2}')

API_ID="00000"
API_HASH="00000000000000000000000000000000"

if [ ! -e .unpacked ]; then
  openssl des3 -d -md sha256 -in ./secure-data.tar.des -out secure-data.tar
  tar -xvf secure-data.tar
  touch .unpacked
fi

if [ -e ./env.bash ]; then
  source ./env.bash
fi

if [ -e encode-keys-android.patch -a ! -e .applied ]; then
  patch -d .. -p1 -i ${c_d}/encode-keys-android.patch
  touch .applied
fi

cd ..

set -x

docker run --rm -it \
   -v $PWD:/home/source/ \
   telegram-android:${TLG_VERSION}

