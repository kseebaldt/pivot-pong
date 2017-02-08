#!/usr/bin/env bash

set -eu -o pipefail

./cf-bin/cf login -a https://api.run.pivotal.io -u $CF_USERNAME -p $CF_PASSWORD -o slackersoft -s seattle-pong

./cf-bin/cf apps | grep seattle-pong-old
if [ $? = 0 ]
then
    echo 'cleaning up deployment space'
    ./cf-bin/cf delete -f seattle-pong

    ./cf-bin/cf rename seattle-pong-old seattle-pong
fi