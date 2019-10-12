#!/usr/bin/env bash

set -e

rm -rf dist/
mkdir dist/

zip -9 -r dist/magic-snail.love . \
    --exclude=*.git/* \
    --exclude=*.idea/* \
    --exclude=*dist/*

cd dist/

# build for windows
wget -q https://bitbucket.org/rude/love/downloads/love-11.2-win64.zip -O love.zip
unzip -q love.zip
rm love.zip
cat love-11.2.0-win64/love.exe magic-snail.love > love-11.2.0-win64/magic-snail.exe
zip -q -9 -r magic-snail-win64.zip love-11.2.0-win64
rm -r love-11.2.0-win64
