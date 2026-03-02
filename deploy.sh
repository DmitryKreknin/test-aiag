#!/bin/bash
# VIZEN.agents — скрипт деплоя на сервер
# Запускать на чистом Ubuntu 22.04/24.04
# Использование: bash deploy.sh [домен]
# Пример: bash deploy.sh vizen-agents.ru
# Без домена — будет работать по IP на порту 80

set -e

DOMAIN=${1:-""}

echo "=== VIZEN.agents — Установка ==="

# 1. Обновление системы
echo "[1/5] Обновление системы..."
sudo apt update && sudo apt upgrade -y

# 2. Установка Docker
echo "[2/5] Установка Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker $USER
fi

# 3. Установка Docker Compose plugin
echo "[3/5] Проверка Docker Compose..."
if ! docker compose version &> /dev/null; then
    sudo apt install -y docker-compose-plugin
fi

# 4. Запуск Dify
echo "[4/5] Запуск VIZEN.agents..."
cd "$(dirname "$0")/docker"
if [ ! -f .env ]; then
    cp .env.example .env
    # Включаем trial apps
    echo "" >> .env
    echo "ENABLE_TRIAL_APP=true" >> .env
fi
sudo docker compose up -d

# 5. Настройка домена + SSL (если указан)
if [ -n "$DOMAIN" ]; then
    echo "[5/5] Настройка домена $DOMAIN + SSL..."
    sudo apt install -y caddy
    sudo tee /etc/caddy/Caddyfile > /dev/null <<EOF
$DOMAIN {
    reverse_proxy localhost:80
}
EOF
    sudo systemctl restart caddy
    echo ""
    echo "=== Готово! ==="
    echo "Открой: https://$DOMAIN"
else
    echo "[5/5] Домен не указан, доступ по IP."
    echo ""
    echo "=== Готово! ==="
    IP=$(curl -s ifconfig.me 2>/dev/null || echo "<IP-сервера>")
    echo "Открой: http://$IP"
fi

echo ""
echo "Первый вход — создай аккаунт администратора."
