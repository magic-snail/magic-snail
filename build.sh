#!/usr/bin/env bash

set -e

rm -rf dist/
mkdir dist/

echo -n 'Building magic-snail.love ... '
zip -q -9 -r dist/magic-snail.love . \
    --exclude=*.git/* \
    --exclude=*.idea/* \
    --exclude=*dist/*
echo 'done.'

cd dist/

# build for windows
echo -n 'Building for Windows (64bit) ... '
wget -q https://bitbucket.org/rude/love/downloads/love-11.2-win64.zip -O love.zip
unzip -q love.zip
rm love.zip
cat love-11.2.0-win64/love.exe magic-snail.love > love-11.2.0-win64/magic-snail.exe
zip -q -j -9 -r magic-snail-win64.zip love-11.2.0-win64
rm -r love-11.2.0-win64
echo 'done.'

# building for macos
echo -n 'Building for MacOS ... '
wget -q https://bitbucket.org/rude/love/downloads/love-11.2-macos.zip -O love.zip
unzip -q love.zip
rm love.zip
mv love.app magic-snail.app
cp magic-snail.love magic-snail.app/Contents/Resources
cp ../assets/build/Info.plist magic-snail.app/Contents/Info.plist
zip -q -9 -y -r magic-snail-macos.zip magic-snail.app
rm -r magic-snail.app
echo 'done.'
