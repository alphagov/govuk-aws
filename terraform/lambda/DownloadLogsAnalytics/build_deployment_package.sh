#! /bin/bash
set -eu

virtualenv -p python3.7 .venv
# shellcheck disable=SC1091
. .venv/bin/activate

mkdir -p wheelhouse

pip install --platform manylinux2014_x86_64 --target=wheelhouse --implementation cp --python 3.7 --only-binary=:all: --upgrade grequests
(
cd wheelhouse
zip -r ../download_logs_analytics.zip .
)
zip -r download_logs_analytics.zip handler.py download_logs

rm -rf wheelhouse
rm -rf .venv
