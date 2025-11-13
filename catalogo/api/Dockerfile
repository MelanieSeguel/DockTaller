# Stage 1: Builder
FROM python:3.11-slim as builder

WORKDIR /app

# Copiar solo los requerimientos primero para aprovechar la caché de Docker
COPY requirements.txt .

# Instalar dependencias
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# Stage 2: Runner
FROM python:3.11-slim

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Crear usuario no root
RUN useradd -m -u 1000 appuser

WORKDIR /app

# Copiar wheels del builder
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .

# Instalar dependencias
RUN pip install --no-cache /wheels/*

# Copiar código de la aplicación
COPY main.py .

# Cambiar al usuario no root
USER appuser

# Exponer puerto
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]