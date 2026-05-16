#!/usr/bin/env bash

set -e

cd /root/hermes/.hermes/hermes-agent

export PATH="/root/.local/bin:$PATH"
export PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

source .venv/bin/activate

python run_agent.py > /dev/null 2>&1 &

sleep 5

hermes gateway run > /dev/null 2>&1 &

sleep 3

exec hermes dashboard \
  --host 0.0.0.0 \
  --port 1000 \
  --insecure \
  --no-open
