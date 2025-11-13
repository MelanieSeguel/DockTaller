FROM postgres:15-alpine

# Copiar script de healthcheck
COPY healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/healthcheck.sh

# Configurar healthcheck
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 \
    CMD ["healthcheck.sh", "localhost", "$POSTGRES_USER", "$POSTGRES_DB", "$POSTGRES_PASSWORD"]

# Copiar scripts de inicialización
COPY seed.sql /docker-entrypoint-initdb.d/

# Configurar locale
ENV LANG es_ES.utf8