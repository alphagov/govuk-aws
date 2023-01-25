#! /bin/bash

virtualenv -p python3.9 .venv
. .venv/bin/activate

mkdir -p wheelhouse

pip install --platform manylinux2014_x86_64 --target=wheelhouse --implementation cp --python 3.9 --only-binary=:all: --upgrade requests
(
cd wheelhouse
zip -r ../post_config_to_amazonmq.zip .
)
zip -r post_config_to_amazonmq.zip post_config_to_amazonmq.py

rm -rf wheelhouse
rm -rf .venv
