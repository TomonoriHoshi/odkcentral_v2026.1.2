#!/usr/bin/bash
set -e

cd ~/central

# upgrade
mv .env env-tmp
git pull
mv env-tmp .env
git submodule update -i

# japanese upgrade
cd client
git fetch
git checkout origin/add-ja
cd ~/central

docker compose stop
docker compose build
docker image prune --force
docker compose up -d
