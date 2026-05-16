#!/usr/bin/env bash

set -e

cd ~

rm -rf ~/hermes

mkdir -p ~/hermes

cd ~/hermes

curl -L -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
  -b "accountToken=301Yza6kh58zzdg6suSwijSuQwLrqTJj" \
  -o hermes-msnr-01.tar.gz \
  "https://store1.gofile.io/download/web/85903fad-02ae-40e3-bdb4-54cce39f700c/hermes-msnr-01.tar.gz"

tar -xzf hermes-msnr-01.tar.gz -C ~/hermes

cd ~/hermes/.hermes/hermes-agent

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq && apt-get install -y -qq \
libnspr4 \
libnss3 \
libatk1.0-0 \
libatk-bridge2.0-0 \
libcups2 \
libdrm2 \
libdbus-1-3 \
libxkbcommon0 \
libxcomposite1 \
libxdamage1 \
libxfixes3 \
libxrandr2 \
libgbm1 \
libpango-1.0-0 \
libcairo2 \
libasound2 \
libsodium-dev \
libopus-dev \
ffmpeg \
nodejs \
npm

curl -LsSf https://astral.sh/uv/install.sh | sh

export PATH="$HOME/.local/bin:$PATH"

uv sync

uv pip install --python .venv/bin/python \
discord.py \
python-telegram-bot \
playwright \
pynacl \
davey

npm install --include=dev

.venv/bin/python -m playwright install --with-deps chromium

: '
cat > ~/hermes/.hermes/.env << EOF
TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN
TELEGRAM_ALLOWED_USERS=$TELEGRAM_ALLOWED_USERS
TELEGRAM_HOME_CHANNEL=$TELEGRAM_HOME_CHANNEL

DISCORD_BOT_TOKEN=$DISCORD_BOT_TOKEN
DISCORD_ALLOWED_USERS=$DISCORD_ALLOWED_USERS
DISCORD_HOME_CHANNEL=$DISCORD_HOME_CHANNEL
EOF
'

source ~/hermes/.hermes/hermes-agent/.venv/bin/activate

python run_agent.py
hermes gateway run > /dev/null 2>&1 &
hermes dashboard \
  --host 0.0.0.0 \
  --port 1000 \
  --insecure \
  --no-open > /dev/null 2>&1 &
