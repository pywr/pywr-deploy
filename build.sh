GIT_URL="https://github.com/pywr/pywr.git"
GIT_TAG="v0.2"

git clone ${GIT_URL}
cd pywr
git fetch --tags
git checkout ${GIT_TAG}

cp conda-recipe/build.sh ../conda-recipe/
conda build ../conda-recipe
