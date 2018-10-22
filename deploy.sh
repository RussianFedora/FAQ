#!/usr/bin/bash
set -e

RESDIR="/tmp/$(date +%s)"

mkdir -p $RESDIR
make clean
make html

cp -r build/html/* $RESDIR
rm -rf build
git checkout gh-pages

rm -rf *
mv $RESDIR/* .
git add -A
git commit -m "Updated FAQ contents."
git push -u origin gh-pages
git checkout master
git reset --hard

rm -rf "$RESDIR"
