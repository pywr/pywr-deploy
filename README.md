# Deploying Pywr releases

This repository is used to deploy pywr releases to conda & pypi. Currently conda
deployment is done using travis (Linux and OSX) and appveyor (Windows). Pypi releases
are a more manual process at the current time.

## Releasing to Anaconda.


Travis: https://travis-ci.org/pywr/pywr-deploy/
Appveyor: https://ci.appveyor.com/project/snorfalorpagus/pywr-deploy

Release process:

* Update version number in `pywr/__init__.py` and `conda-recipe/meta.yaml` to release.
* Tag release: `git tag -a vX.X -m "Release X.X"`
* Update version number in `pywr/__init__.py` and `conda-recipe/meta.yaml` to development.
* Push tag: `git push origin vX.X`
* Update version number and git_rev in `pywr-deploy/meta.yaml`
* Push to deploy!


## Releasing to Pypi

### Source distribution

Simply compile the source distribution locally from the appropriate tagged commit of Pywr.
Then upload using `twine`.

```
python setup.py sdist
```

### Linux wheels

Once the new release is tagged and available on Github the `build-wheels.sh` script
can be used inside a specific docker container to build all of the Linux wheels. This
process builds GLPK inside the `manylinux1` container and then builds wheels for all
the versions of Python required.

```
docker run -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/build-wheels.sh
```

After completing the wheels should be located in the `wheelhouse` folder of the `pywr-deploy`
repository. These can then be uploaded to pypi using `twine`.

```
twine upload wheelhouse/*
```
 
Note there is no deployment of Python 2.x wheels. It's too much effort.
