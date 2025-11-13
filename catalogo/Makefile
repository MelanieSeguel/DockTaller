.PHONY: up down logs backup restore build ps clean

# Variables
BACKUP_FILE ?= backup.sql
COMPOSE = docker compose

# Comandos principales
up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

# Comandos de escalamiento
scale-api:
	$(COMPOSE) up -d --scale api=2

# Comandos de backup/restore
backup:
	$(COMPOSE) exec db pg_dump -U $$POSTGRES_USER -d $$POSTGRES_DB > $(BACKUP_FILE)
	@echo "Backup creado en: $(BACKUP_FILE)"

restore:
	@if [ ! -f "$(BACKUP_FILE)" ]; then \
		echo "Error: Archivo de backup no encontrado: $(BACKUP_FILE)"; \
		exit 1; \
	fi
	$(COMPOSE) exec -T db psql -U $$POSTGRES_USER -d $$POSTGRES_DB < $(BACKUP_FILE)
	@echo "Restauración completada desde: $(BACKUP_FILE)"

# Comandos de construcción y limpieza
build:
	$(COMPOSE) build

clean:
	$(COMPOSE) down -v --remove-orphans
	rm -f *.sql

# Comandos de ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  make up              - Inicia todos los servicios"
	@echo "  make down            - Detiene todos los servicios"
	@echo "  make logs            - Muestra los logs de todos los servicios"
	@echo "  make ps              - Muestra el estado de los servicios"
	@echo "  make scale-api       - Escala el servicio API a 2 instancias"
	@echo "  make backup          - Crea un backup de la base de datos"
	@echo "  make restore         - Restaura la base de datos desde un backup"
	@echo "  make build           - Construye las imágenes"
	@echo "  make clean           - Limpia todos los recursos"