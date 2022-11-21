#!/bin/sh
export WORK_DIR=$PWD

rm -rf "$WORK_DIR/SourceRepository"
git clone https://github.com/miyouzi/aniGamerPlus.git "$WORK_DIR/SourceRepository"
cp -f "$WORK_DIR/SourceRepository/sn_list-sample.txt" "$WORK_DIR/sn_list-sample.txt"
[ ! -f "$WORK_DIR/sn_list.txt" ] && touch "$WORK_DIR/sn_list.txt"
[ ! -f "$WORK_DIR/aniGamer.db" ] && touch "$WORK_DIR/aniGamer.db"
[ ! -f "$WORK_DIR/cookie.txt" ] && touch "$WORK_DIR/cookie.txt"
if [ ! -f "$WORK_DIR/config.json" ]; then
    cp -f "$WORK_DIR/SourceRepository/config-sample.json" "$WORK_DIR/config.json"
    sed -i 's/127.0.0.1/0.0.0.0/g' "$WORK_DIR/config.json"
fi

cd "$WORK_DIR/SourceRepository"
export APP_TAG=$(git describe --tags --abbrev=0)-$(git rev-parse --short HEAD)
cd "$WORK_DIR"
docker build -t ani-gamer-plus:latest --no-cache -t ani-gamer-plus:${APP_TAG} .
