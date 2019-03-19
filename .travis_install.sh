#!/bin/bash

echo "Travis install script"
echo "TRAVIS_OS_NAME $TRAVIS_OS_NAME"

if test "$TRAVIS_OS_NAME" = "linux"; then
    echo "Nothing required to install yet"
fi

