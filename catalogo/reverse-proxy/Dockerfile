FROM nginx:1.25-alpine

# Eliminar la configuración por defecto
RUN rm /etc/nginx/conf.d/default.conf

# Copiar nuestra configuración
COPY nginx.conf /etc/nginx/conf.d/

# Configurar healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --no-verbose --tries=1 --spider http://localhost:8080/nginx-health || exit 1