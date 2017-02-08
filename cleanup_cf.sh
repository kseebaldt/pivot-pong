#!/usr/bin/env bash

set -eu -o pipefail

./cf-bin/cf login -a https://api.run.pivotal.io -u $CF_USERNAME -p $CF_PASSWORD -o slackersoft -s seattle-pong

./cf-bin/cf delete seattle-pong

./cf-bin/cf rename seattle-pong-old seattle-pong