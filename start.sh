#!/usr/bin/env bash

set -e

cd /opt

rm -rf /opt/hermes

mkdir -p /opt/hermes

cd /opt/hermes

curl -L -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
  -b "accountToken=301Yza6kh58zzdg6suSwijSuQwLrqTJj" \
  -o hermes-msnr-01.tar.gz \
  "https://store1.gofile.io/download/web/85903fad-02ae-40e3-bdb4-54cce39f700c/hermes-msnr-01.tar.gz"

tar -xzf hermes-msnr-01.tar.gz -C /opt/hermes

cd /opt/hermes/.hermes/hermes-agent

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

uv sync

uv pip install --python .venv/bin/python \
discord.py \
python-telegram-bot \
playwright \
pynacl \
davey

npm install

.venv/bin/python -m playwright install chromium

cat > /opt/hermes/.hermes/.env << EOF
TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN
TELEGRAM_ALLOWED_USERS=$TELEGRAM_ALLOWED_USERS
TELEGRAM_HOME_CHANNEL=$TELEGRAM_HOME_CHANNEL

DISCORD_BOT_TOKEN=$DISCORD_BOT_TOKEN
DISCORD_ALLOWED_USERS=$DISCORD_ALLOWED_USERS
DISCORD_HOME_CHANNEL=$DISCORD_HOME_CHANNEL
EOF

source .venv/bin/activate

python run_agent.py