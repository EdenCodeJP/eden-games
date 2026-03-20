#!/bin/bash
# ==============================================
# EdenGames — Vercel 一発デプロイスクリプト
# 使い方: ./deploy.sh <game-name>
# 例:     ./deploy.sh jelly-blocks
# ==============================================

GAME="$1"
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_DIR="$REPO_ROOT/$GAME"

# ---- 引数チェック ----
if [ -z "$GAME" ]; then
  echo ""
  echo "使い方: ./deploy.sh <game-name>"
  echo "例:     ./deploy.sh jelly-blocks"
  echo ""
  echo "利用可能なゲーム:"
  for d in "$REPO_ROOT"/*/; do
    name=$(basename "$d")
    if [ -f "$d/index.html" ]; then
      echo "  ✓ $name"
    fi
  done
  echo ""
  exit 1
fi

# ---- フォルダチェック ----
if [ ! -d "$GAME_DIR" ]; then
  echo "エラー: '$GAME_DIR' が見つかりません"
  exit 1
fi

if [ ! -f "$GAME_DIR/index.html" ]; then
  echo "警告: '$GAME_DIR/index.html' が見つかりません"
fi

# ---- Vercel CLI チェック ----
if ! command -v vercel &>/dev/null; then
  echo ""
  echo "Vercel CLI が見つかりません。インストールします..."
  npm install -g vercel
  if ! command -v vercel &>/dev/null; then
    echo "インストール失敗。npm が入っているか確認してください。"
    exit 1
  fi
fi

# ---- デプロイ ----
echo ""
echo "=========================================="
echo "  Deploying: $GAME"
echo "  Directory: $GAME_DIR"
echo "=========================================="
echo ""

vercel "$GAME_DIR" \
  --prod \
  --yes \
  --name "$GAME"

if [ $? -eq 0 ]; then
  echo ""
  echo "=========================================="
  echo "  デプロイ完了！"
  echo "  URL: https://$GAME.vercel.app"
  echo "=========================================="
else
  echo ""
  echo "デプロイ失敗。エラーを確認してください。"
  exit 1
fi
