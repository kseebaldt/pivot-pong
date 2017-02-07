#!/usr/bin/env bash

set -euv -o pipefail

mkdir -p cf-bin

wget --progress=dot --show-progress --output-document=cf-bin/cf-cli.tgz https://cli.run.pivotal.io/stable?release=linux64-binary&source=github

cd cf-bin
echo `ls`
tar -xzf cf-cli.tgz