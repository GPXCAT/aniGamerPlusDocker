#!/bin/sh
# 初始化執行所需的檔案 (已存在的不會覆蓋)
set -eu
cd "$(dirname "$0")"

RAW=https://raw.githubusercontent.com/miyouzi/aniGamerPlus/master

fetch() {
    if command -v curl >/dev/null 2>&1; then curl -fsSL "$1" -o "$2"
    else wget -qO "$2" "$1"; fi
}

[ -f .env ] || { cp .env.example .env; echo "建立 .env"; }

for f in aniGamer.db cookie.txt sn_list.txt; do
    [ -f "$f" ] || { touch "$f"; echo "建立 $f"; }
done

mkdir -p bangumi logs

fetch "$RAW/sn_list-sample.txt" sn_list-sample.txt

if [ ! -f config.json ]; then
    fetch "$RAW/config-sample.json" config.json
    # 只修改 dashboard 的 host，讓容器外可以連線
    sed -i 's/"host": "127.0.0.1"/"host": "0.0.0.0"/' config.json
    echo "建立 config.json"
fi

echo "完成。請把巴哈姆特 cookie 貼到 cookie.txt，再執行 docker compose up -d --build"
