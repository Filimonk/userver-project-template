# ---- Settings ----
COMPOSE_DEBUG := docker compose -f docker-compose.debug.yaml
COMPOSE_RELEASE := docker compose -f docker-compose.release.yaml
S ?=  # Переменная для перечисления сервисов, логи которых хотим получить

# Определяем UID и GID хоста.
# Если запускаем от root (UID=0), то берём 1000:1000
UID := $(shell id -u)
GID := $(shell id -g)
ifeq ($(UID),0)
  UID := 1000
  GID := 1000
endif

export UID
export GID

.PHONY: up-debug down-debug logs-debug ps-debug up down logs ps

# Поднимаем окружение в фоне, с билдом образов.
up-debug:
	$(COMPOSE_DEBUG) up --build -d
up: up-debug

# Останавливаем и чистим контейнеры/сеть этого проекта.
down-debug:
	$(COMPOSE_DEBUG) down --remove-orphans
down: down-debug

# Логи всех сервисов, или конкретного (через S=имя)
logs-debug:
	$(COMPOSE_DEBUG) logs -f $(S)
logs: logs-debug

# Статус контейнеров
ps-debug:
	$(COMPOSE_DEBUG) ps
ps: ps-debug


.PHONY: up-release down-release logs-release ps-release

# Поднимаем окружение в фоне, с билдом образов.
up-release:
	$(COMPOSE_RELEASE) up --build -d

# Останавливаем и чистим контейнеры/сеть этого проекта.
down-release:
	$(COMPOSE_RELEASE) down --remove-orphans

# Логи всех сервисов, или конкретного (через S=имя)
logs-release:
	$(COMPOSE_RELEASE) logs -f $(S)

# Статус контейнеров
ps-release:
	$(COMPOSE_RELEASE) ps

