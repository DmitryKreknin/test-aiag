# VIZEN.agents — Инструкция по деплою

## Требования к серверу
- Ubuntu 22.04 или 24.04
- Минимум 4GB RAM, 2 CPU, 40GB SSD
- Открытые порты: 80, 443

## Быстрый деплой (1 команда)

```bash
git clone <url-репозитория> vizen-agents
cd vizen-agents
bash deploy.sh
```

С доменом:
```bash
bash deploy.sh vizen-agents.ru
```

## Что сделает скрипт
1. Обновит систему
2. Установит Docker и Docker Compose
3. Поднимет все сервисы (API, БД, Redis, фронтенд)
4. Если указан домен — настроит Caddy с автоматическим SSL

## После установки
1. Открыть http://<IP> или https://<домен>
2. Создать аккаунт администратора
3. Настроить Model Provider (Settings → Model Provider → добавить API ключ)

## Управление

```bash
cd vizen-agents/docker

# Статус контейнеров
docker compose ps

# Остановить
docker compose down

# Запустить
docker compose up -d

# Логи
docker compose logs -f api

# Обновить
docker compose pull && docker compose up -d
```

## Конфигурация
Основной файл настроек: `docker//.env`
