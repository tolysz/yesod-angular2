#!/usr/bin/env bash

# rm -rf yesod-devel dist .stack-work static/tmp && stack clean
stack build
stack install yesod-bin
#PATH=`stack path --bin-path  --stack-yaml stack.yaml 2>/dev/null`:$PATH

stack exec -- yesod devel
