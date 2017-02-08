#!/usr/bin/env bash

set -euv -o pipefail

mkdir -p cf-bin
cd cf-bin

wget -O cf-cli.tgz https://cli.run.pivotal.io/stable?release=linux64-binary&source=github

ls
tar -xzf cf-cli.tgz