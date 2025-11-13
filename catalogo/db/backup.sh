#!/bin/bash
set -e

# Variables de entorno necesarias:
# POSTGRES_USER
# POSTGRES_DB
# BACKUP_PATH (opcional, por defecto: /backups)

BACKUP_PATH=${BACKUP_PATH:-/backups}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_PATH}/backup_${TIMESTAMP}.sql"

# Asegurar que existe el directorio de backups
mkdir -p "$BACKUP_PATH"

# Realizar el backup
echo "Iniciando backup de la base de datos ${POSTGRES_DB}..."
pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" > "$BACKUP_FILE"

echo "Backup completado: $BACKUP_FILE"