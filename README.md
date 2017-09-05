This repository is used to deploy pywr releases to conda.

Travis: https://travis-ci.org/pywr/pywr-deploy/
Appveyor: https://ci.appveyor.com/project/snorfalorpagus/pywr-deploy

Release process:

* Update version number in `pywr/__init__.py` and `conda-recipe/meta.yaml` to release.
* Tag release: `git tag -a vX.X -m "Release X.X"`
* Update version number in `pywr/__init__.py` and `conda-recipe/meta.yaml` to development.
* Push tag: `git push origin vX.X`
* Update version number and git_rev in `pywr-deploy/meta.yaml`
* Push to deploy!
