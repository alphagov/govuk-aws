#! /bin/bash -x
VERSION=3.8

pyenv install ${VERSION}
pyenv global ${VERSION}

PYTHON=$(pyenv which "python${VERSION}")
virtualenv -p $PYTHON venv
source venv/bin/activate

mkdir -p wheelhouse

pip3 --python ${PYTHON} install --platform manylinux2014_x86_64 --target=wheelhouse --implementation cp --only-binary=:all: --upgrade grequests
pip3 install -r requirements.txt
(
cd wheelhouse
zip -r ../download_logs_analytics.zip .
)
zip -r download_logs_analytics.zip handler.py download_logs
rm -rf wheelhouse
rm -rf venv
