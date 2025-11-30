#!/usr/bin/env zsh

TARGET_DIR="/Users/$USER/MineEnv-1-18"
SETUP_DIR="$(cd "$(dirname "$0")" && pwd)"
SEARCH_ROOT="/Users/$USER"

spinner() {
    local pid=$1
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r検索中... %s" "${spin:$i:1}"
        sleep 0.1
    done
    printf "\r検索完了！    \n"
}

if [ -d "$TARGET_DIR" ]; then
    echo "MineEnv-1-18 が見つかりました。"
    cd "$TARGET_DIR"
else
    echo "MineEnv-1-18 が見つかりません。探索を開始します..."
    echo "時間がかかる場合があります。"
    echo "検索ルート: $SEARCH_ROOT"

    TMP_FILE=$(mktemp)

    {
        FOUND_DIR=$(find "$SEARCH_ROOT" -type f -name "build.gradle" \
            -path "*/MineEnv-1-18/*" 2>/dev/null \
            | sed 's#/build.gradle##' \
            | head -n 1)
        echo "$FOUND_DIR" > "$TMP_FILE"
    } &

    FIND_PID=$!
    spinner $FIND_PID

    FOUND_DIR=$(cat "$TMP_FILE")
    rm "$TMP_FILE"

    if [ -n "$FOUND_DIR" ]; then
        echo "ディレクトリを発見: $FOUND_DIR"
        TARGET_DIR="$FOUND_DIR"
        cd "$TARGET_DIR"
    else
        echo "エラー: $SEARCH_ROOT 内に MineEnv-1-18 + build.gradle が見つかりませんでした。"
        exit 1
    fi
    echo "MineEnv-1-18 が見つかりました。"
fi