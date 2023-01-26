#! /bin/bash

virtualenv -p python3.9 .venv
. .venv/bin/activate

mkdir -p package

pip install --platform manylinux2014_x86_64 --target=package --implementation cp --python 3.9 --only-binary=:all: -r requirements.txt
(
cd package
zip -r ../post_config_to_amazonmq.zip .
)
zip -r post_config_to_amazonmq.zip post_config_to_amazonmq.py

rm -rf package
rm -rf .venv
