#!/bin/bash

declare currentDir=$(cd $(dirname $0);pwd)

if [ "$TRAVIS_BRANCH" != "master" ] ; then
    exit 0;
fi

if [ $TRAVIS_PULL_REQUEST != 'false' ]; then
    echo "This is a pull request. No deployment will be done.";
    exit 0;
fi

git checkout -B gh-pages

make html
npm run build-js-min

make pdf

lastCommit=$(git log --oneline | head -n 1)
echo "=COMMIT="
echo "MESSAGE :" $lastCommit

git add -A .
git commit --quiet -m "Travis build $TRAVIS_BUILD_NUMBER"
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" gh-pages > /dev/null
