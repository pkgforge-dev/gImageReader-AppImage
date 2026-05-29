#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q gimagereader-qt | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/gimagereader.png
export DESKTOP=/usr/share/applications/gimagereader-qt6.desktop

# Deploy dependencies
quick-sharun \
	/usr/bin/gimagereader-qt6 \
	/usr/bin/tesseract

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
