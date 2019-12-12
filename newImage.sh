#!/bin/bash

wget -O- https://get.pharo.org/64/70+vm | bash

./pharo-ui Pharo.image st scripts/loadImage.st
