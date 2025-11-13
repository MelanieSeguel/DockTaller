#!/bin/bash
set -e

# Variables de entorno necesarias:
# POSTGRES_USER
# POSTGRES_DB
# BACKUP_FILE

if [ -z "$BACKUP_FILE" ]; then
    echo "Error: BACKUP_FILE no está definido"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: El archivo de backup no existe: $BACKUP_FILE"
    exit 1
fi

echo "Iniciando restauración desde $BACKUP_FILE..."
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" < "$BACKUP_FILE"

echo "Restauración completada"