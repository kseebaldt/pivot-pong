#!/usr/bin/env bash

set -eu -o pipefail

mkdir -p cf-bin

wget --output-document=cf-bin/cf-cli.tgz https://cli.run.pivotal.io/stable?release=linux64-binary&source=github

cd cf-bin
ls
tar -xzf cf-cli.tgz