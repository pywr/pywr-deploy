#!/bin/bash
# Build script for use with manylinux1 docker image to construct Linux wheels
# Note this script does not build the wheels with lpsolve support.
set -e -x

export GLPK_VERSION=4.65
export PYWR_VERSION=1.1.0
export PYWR_TAG=v1.1.0
export WORKDIR=${HOME}

cd ${WORKDIR}

# Download GLPK
curl http://ftp.gnu.org/gnu/glpk/glpk-${GLPK_VERSION}.tar.gz -o glpk-${GLPK_VERSION}.tar.gz
tar -xvf glpk-${GLPK_VERSION}.tar.gz
cd glpk-${GLPK_VERSION}

# Build & install GLPK
./configure
make
make check
make install


cd ${WORKDIR}

rm -rf pywr
git clone https://github.com/pywr/pywr.git
cd pywr
git checkout ${PYWR_TAG}


# Support binaries
PYBINS=( /opt/python/cp36-cp36m/bin )

# Compile wheels
for PYBIN in "${PYBINS[@]}"; do
    "${PYBIN}/pip" install -r /io/dev-requirements.txt --no-build-isolation --only-binary pandas
    PYWR_BUILD_GLPK="true" "${PYBIN}/pip" wheel --no-deps ./ -w ${WORKDIR}/wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in ${WORKDIR}/wheelhouse/pywr*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in "${PYBINS[@]}"; do
    "${PYBIN}/pip" install pywr --no-index -f /io/wheelhouse
    "${PYBIN}/py.test" ${WORKDIR}/pywr/tests
done
