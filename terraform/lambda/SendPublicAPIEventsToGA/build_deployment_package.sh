#! /bin/bash -x
VERSION=3.8

pyenv install ${VERSION}
pyenv global ${VERSION}

PYTHON=$(pyenv which "python${VERSION}")

virtualenv -p $PYTHON venv
source venv/bin/activate

mkdir -p wheelhouse

pip3 --python ${PYTHON} install --platform manylinux2014_x86_64 --target=wheelhouse --implementation cp --only-binary=:all: --upgrade grequests
(
cd wheelhouse
zip -r ../send_public_events_to_ga.zip .
)
zip -r send_public_events_to_ga.zip send_public_api_events_to_ga.py

rm -rf wheelhouse
rm -rf venv
