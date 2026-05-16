FROM python:3.11

WORKDIR /root

# ============================================
# System dependencies
# ============================================

RUN apt-get update && apt-get install -y \
    git \
    curl \
    ffmpeg \
    nodejs \
    npm \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# Install uv
# ============================================

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/root/.local/bin:$PATH"

# ============================================
# Playwright browser path
# ============================================

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN mkdir -p /ms-playwright

# ============================================
# Download Hermes backup
# ============================================

RUN mkdir -p /root/hermes

WORKDIR /root/hermes

RUN curl -L -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
    -b "accountToken=301Yza6kh58zzdg6suSwijSuQwLrqTJj" \
    -o hermes-msnr-01.tar.gz \
    "https://store1.gofile.io/download/web/85903fad-02ae-40e3-bdb4-54cce39f700c/hermes-msnr-01.tar.gz"

RUN tar -xzf hermes-msnr-01.tar.gz -C /root/hermes

# ============================================
# Hermes setup
# ============================================

WORKDIR /root/hermes/.hermes/hermes-agent

RUN uv sync

RUN uv pip install --python .venv/bin/python \
    fastapi \
    uvicorn \
    discord.py \
    python-telegram-bot \
    playwright \
    pynacl \
    davey

RUN npm install --include=dev

# ============================================
# Install Chromium once during build
# ============================================

RUN PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    .venv/bin/python -m playwright install --with-deps chromium

# ============================================
# Copy startup script
# ============================================

COPY start.sh /start.sh

RUN chmod +x /start.sh

# ============================================
# Expose dashboard port
# ============================================

EXPOSE 1000

# ============================================
# Start container
# ============================================

CMD ["/start.sh"]
