#!/usr/bin/bash
# Fedora-Faq-Ru (c) 2018 - 2020, EasyCoding Team and contributors
#
# Fedora-Faq-Ru is licensed under a
# Creative Commons Attribution-ShareAlike 4.0 International License.
#
# You should have received a copy of the license along with this
# work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.

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
touch .nojekyll
git add -A
git commit -m "Updated FAQ contents."
git checkout master
git reset --hard

rm -rf "$RESDIR"
