# Cross-compiling example project

This example project uses Clang/LLVM to cross-compile a simple app for running on Mac and Windows.

Currently, it is assumed that you will build the app on a Mac host.

Mac build:

    ./mac/build/build.sh

Windows build (32bit):

    ./win/build/build.sh

Windows build (64bit):

    ARCH=amd64 ./win/build/build.sh
