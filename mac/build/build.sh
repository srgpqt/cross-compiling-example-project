#!/bin/sh

set -e

BUILDDIR="$( dirname "${BASH_SOURCE[0]}" )"
BUNDLE="$BUILDDIR/Example.app"
PROJECT_DIR="$BUILDDIR/../.."

CC="clang"
CFLAGS="-Wall -arch x86_64 -mmacosx-version-min=10.7 -fpic"
LDFLAGS=""

if [ "$DEBUG" = "1" ]; then
	CFLAGS="$CFLAGS -g -O0 -DDEBUG=1"
	LDFLAGS="$LDFLAGS -g"
else
	CFLAGS="$CFLAGS -Os"
fi

LDFLAGS="$LDFLAGS -framework Cocoa"
LDFLAGS="$LDFLAGS -framework OpenGL"

mkdir -p "$BUNDLE/Contents/MacOS"

$CC -o "$BUNDLE/Contents/MacOS/Example" $CFLAGS $LDFLAGS "$PROJECT_DIR/mac/main.m" "$PROJECT_DIR/lib/lib.c"

codesign --force --sign - "$BUNDLE"
touch "$BUNDLE"
