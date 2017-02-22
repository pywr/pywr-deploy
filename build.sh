GIT_URL="https://github.com/pywr/pywr.git"
GIT_TAG="v2.0"

git clone ${GIT_URL}
cd pywr
git checkout ${GIT_TAG}

conda build conda-recipe
