#! /bin/bash

virtualenv -p python3.11 .venv
. .venv/bin/activate

mkdir -p wheelhouse

pip3 install --platform manylinux2014_x86_64 --target=wheelhouse --implementation cp --python 3.11 --only-binary=:all: --upgrade grequests
(
cd wheelhouse
zip -r ../send_public_events_to_ga.zip .
)
zip -r send_public_events_to_ga.zip send_public_api_events_to_ga.py

rm -rf wheelhouse
rm -rf .venv
