#!/bin/sh
export WORK_DIR=$PWD

rm -rf "$PWD/SourceRepository"
git clone https://github.com/miyouzi/aniGamerPlus.git "$PWD/SourceRepository"
rm -f "$PWD/SourceRepository/Dockerfile"
rm -f "$PWD/SourceRepository/docker-compose.yml"
cp -f "$PWD/SourceRepository/.dockerignore" "$PWD/.dockerignore"
cp -f "$PWD/SourceRepository/sn_list-sample.txt" "$PWD/sn_list-sample.txt"
[ ! -f "$PWD/config.json" ] && cp -f "$PWD/SourceRepository/config-sample.json" "$PWD/config.json"
[ ! -f "$PWD/sn_list.txt" ] && touch "$PWD/sn_list.txt"
[ ! -f "$PWD/aniGamer.db" ] && touch "$PWD/aniGamer.db"
[ ! -f "$PWD/cookie.txt" ] && touch "$PWD/cookie.txt"

cd "$PWD/SourceRepository"
export APP_TAG=$(git describe --tags --abbrev=0)-$(git rev-parse --short HEAD)
cd "$PWD"
echo "APP_TAG=${APP_TAG}" > $PWD/.env
echo "ani-gamer-plus:${APP_TAG}"
docker-compose build --no-cache
