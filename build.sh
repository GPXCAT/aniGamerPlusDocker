#!/bin/sh
# 以上游最新 commit 建置映像檔，並同時標上 latest 與版本 tag (例: v25.2-e8f1f56)
# 用法: ./build.sh [branch|tag|commit]   (預設 master)
set -eu
cd "$(dirname "$0")"

REPO=https://github.com/miyouzi/aniGamerPlus.git
REF=${1:-master}

./setup.sh

# 不用 clone，直接查遠端版本
SHA=$(git ls-remote "$REPO" "$REF" "refs/tags/$REF^{}" | head -n1 | cut -c1-7)
[ -n "$SHA" ] || SHA=$(echo "$REF" | cut -c1-7)   # REF 本身就是 commit
TAG=$(git ls-remote --tags --sort=-v:refname "$REPO" 'v*' | grep -v '\^{}' | head -n1 | sed 's#.*refs/tags/##')
APP_TAG="${TAG}-${SHA}"

echo "Build ani-gamer-plus:${APP_TAG} (ref: ${REF})"
docker build --pull \
    --build-arg REF="$SHA" \
    -t ani-gamer-plus:latest \
    -t "ani-gamer-plus:${APP_TAG}" .
