#! /bin/bash

virtualenv -p python3.8 .venv
. .venv/bin/activate

mkdir -p wheelhouse

pip3 install --platform manylinux2014_x86_64 --target=wheelhouse --implementation cp --python 3.8 --only-binary=:all: --upgrade grequests
(
cd wheelhouse
zip -r ../download_logs_analytics.zip .
)
zip -r download_logs_analytics.zip handler.py download_logs

rm -rf wheelhouse
rm -rf .venv
