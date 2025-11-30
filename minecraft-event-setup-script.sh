#!/usr/bin/env zsh

TARGET_DIR="/Users/$USER/MineEnv-1-18"
SETUP_DIR="$(pwd)/setup"
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

    {
        FOUND_DIR=$(find "$SEARCH_ROOT" -type f -name "build.gradle" \
            -path "*/MineEnv-1-18/*" 2>/dev/null \
            | sed 's#/build.gradle##' \
            | head -n 1)
        echo "$FOUND_DIR" > /tmp/mineenv_found_dir.txt
    } &

    FIND_PID=$!
    spinner $FIND_PID

    FOUND_DIR=$(cat /tmp/mineenv_found_dir.txt)
    rm /tmp/mineenv_found_dir.txt

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
echo "決起会のセットアップを開始します。"
printf "MineEnv-1-18 ディレクトリを変更してもよろしいですか？ (y/N): "
read -r ANSWER

if [[ "$ANSWER" != "y" && "$ANSWER" != "Y" ]]; then
    echo "操作がキャンセルされました。"
    exit 0
fi

if [ -d "src" ]; then
    printf "src フォルダをバックアップしますか？ (y/N): "
    read -r BACKUP_SRC
    if [[ "$BACKUP_SRC" == "y" || "$BACKUP_SRC" == "Y" ]]; then
        ZIP_NAME="MineEnv-src-backup-$(date +%Y%m%d%H%M%S).zip"
        zip -r "$HOME/Desktop/$ZIP_NAME" src >/dev/null
        mkdir "/Users/$USER/tmp/minecraft-event/"
        rm -rf "/Users/$USER/tmp/minecraft-event/src"
        cp -R src "/Users/$USER/tmp/minecraft-event/src"
        echo "src をバックアップしました。"
    fi
fi

if [ -f "build.gradle" ]; then
    printf "build.gradle をバックアップしますか？ (y/N): "
    read -r BACKUP_GRADLE
    if [[ "$BACKUP_GRADLE" == "y" || "$BACKUP_GRADLE" == "Y" ]]; then
        ZIP_NAME="MineEnv-gradle-backup-$(date +%Y%m%d%H%M%S).zip"
        zip "$HOME/Desktop/$ZIP_NAME" build.gradle >/dev/null
        cp build.gradle "/Users/$USER/tmp/minecraft-event/build.gradle"
        echo "build.gradle をバックアップしました。"
    fi
fi

rm -rf "src"
rm "build.gradle"
unzip "$SETUP_DIR/src.zip" >/dev/null

mkdir "src/main/java/com/example/examplemod/EditHere"
mkdir -p "src/main/resources/data/examplemod/loot_tables/blocks"
mkdir -p "src/main/resources/data/examplemod/recipes"
mkdir -p "src/main/resources/data/minecraft/tags/items"
cp "$SETUP_DIR/build.gradle" .

cat "$SETUP_DIR/ascii-art.txt"
echo "IntelliJ を起動しています..."

open -a "IntelliJ IDEA CE.app" "$TARGET_DIR"