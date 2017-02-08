#!/usr/bin/env bash

if [ -f cf-bin/cf ]
then
        echo 'already have cf'
        exit 0
fi

set -euv -o pipefail

mkdir -p cf-bin
cd cf-bin

wget --no-background -O cf-cli.tgz https://cli.run.pivotal.io/stable?release=linux64-binary&source=github

sleep 30
tar -xzf cf-cli.tgz
rm cf-cli.tgz