#!/bin/sh

set -e

BUILDDIR="$( dirname "${BASH_SOURCE[0]}" )"
PROJECT_DIR="$BUILDDIR/../.."

if [ "$WDK_ROOT" = "" ]; then
	WDK_ROOT="/opt/WinDDK/7600.16385.win7_wdk.100208-1538"
fi

if [ ! -d "$WDK_ROOT" ]; then
	echo "# Windows DDK (Driver Development Kit) not found at $WDK_ROOT"
	echo "# You can set the WDK_ROOT environment variable to point to the correct WDK directory if it can be found elsewhere."
	echo " "
	echo "# You can download it here:"
	echo "# https://www.microsoft.com/download/confirmation.aspx?id=11800"
	echo " "
	echo "# You'll need to extract (or install) the headers and libs found inside the WDK directory of the ISO."
	echo "# You can do that from a Windows machine or using WINE."
	echo " "
	echo "# The WINE method would look something like this:"
	echo " "
	echo "brew install wine winetricks"
	echo "winetricks mfc42"
	echo " "
	echo "# Then, you would run the following commands from the commandline in the mounted volume:"
	echo " "
	echo "msiexec /i WDK/headers.msi"
	echo "msiexec /i WDK/libs_x64fre.msi"
	echo "msiexec /i WDK/libs_x86fre.msi"
	echo " "
	echo "# msiexec puts the files in C:\\WinDDK, so you may want to move it:"
	echo " "
	echo "mv ~/.wine/drive_c/WinDDK /opt/"
	exit 1
fi

if [ "`which lld-link.exe`" = "" ]; then
	echo "# A lld-link.exe binary from LLVM is required but could not be found in your PATH."

	if [ -e "`brew --prefix llvm`/bin/lld-link" ]; then
		echo "# However, you seem to have one from Homebrew. You could symlink it:"
		echo " "
		echo "ln -s \"`brew --prefix llvm`/bin/lld-link\" /usr/local/bin/lld-link.exe"
	else
		echo "# You must install LLVM through Homebrew:"
		echo " "
		echo "brew install llvm"
	fi
	exit 1
fi

CC="clang"
CFLAGS="-Wall -fpic -fno-exceptions -fuse-ld=lld-link -DUNICODE -D_UNICODE"
LDFLAGS="-nostdinc -nostdlib -Xlinker -subsystem:WINDOWS"

if [ "$DEBUG" = "1" ]; then
	CFLAGS="$CFLAGS -g -O0 -DDEBUG=1"
	LDFLAGS="$LDFLAGS -g"
else
	CFLAGS="$CFLAGS -Os"
fi

if [ "$ARCH" = "amd64" ]; then
	CFLAGS="$CFLAGS -target x86_64-pc-windows-msvc"
	LDFLAGS="$LDFLAGS -Xlinker -libpath:$WDK_ROOT/lib/Crt/amd64"
	LDFLAGS="$LDFLAGS -Xlinker -libpath:$WDK_ROOT/lib/win7/amd64"
else
	CFLAGS="$CFLAGS -target i686-pc-windows-msvc"
	LDFLAGS="$LDFLAGS -Xlinker -libpath:$WDK_ROOT/lib/Crt/i386"
	LDFLAGS="$LDFLAGS -Xlinker -libpath:$WDK_ROOT/lib/win7/i386"
fi

CFLAGS="$CFLAGS -isystem $WDK_ROOT/inc/crt"
CFLAGS="$CFLAGS -isystem $WDK_ROOT/inc/api"
LDFLAGS="$LDFLAGS -Xlinker -defaultlib:msvcrt"
LDFLAGS="$LDFLAGS -Xlinker -defaultlib:user32"

$CC -o "$BUILDDIR/Example.exe" $CFLAGS $LDFLAGS "$PROJECT_DIR/win/main.c" "$PROJECT_DIR/lib/lib.c"
