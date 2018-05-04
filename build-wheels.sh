#!/bin/bash
# Build script for use with manylinux1 docker image to construct Linux wheels
# Note this script does not build the wheels with lpsolve support.
set -e -x

export GLPK_VERSION=4.65
export PYWR_VERSION=0.5.1
export PYWR_TAG=v0.5.1
export WORKDIR=${HOME}

cd ${WORKDIR}

# Download GLPK
wget http://ftp.gnu.org/gnu/glpk/glpk-${GLPK_VERSION}.tar.gz
tar -xvf glpk-${GLPK_VERSION}.tar.gz
cd glpk-${GLPK_VERSION}

# Build & install GLPK
./configure
make
make check
make install


cd ${WORKDIR}

# Fetch Pywr
# Old version of wget/OpenSSL in the manylinux image does not with Github.
# For now just manually download this archive.
#wget  --no-check-certificate https://github.com/pywr/pywr/archive/${PYWR_VERSION}.tar.gz
#tar -xvf pywr-${PYWR_VERSION}.tar.gz


rm -rf pywr
git clone https://github.com/pywr/pywr.git
cd pywr
git checkout ${PYWR_TAG}


# Compile wheels
for PYBIN in /opt/python/cp3*/bin; do
    "${PYBIN}/pip" install -r /io/dev-requirements.txt --no-build-isolation --only-binary pandas
    PYWR_BUILD_GLPK="true" "${PYBIN}/pip" wheel --no-deps ./ -w ${WORKDIR}/wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in ${WORKDIR}/wheelhouse/pywr*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/cp3*/bin/; do
    "${PYBIN}/pip" install pywr --no-index -f /io/wheelhouse
    "${PYBIN}/py.test" ${WORKDIR}/pywr/tests
done
