# README de entrega — Catálogo con API, Postgres y Nginx

Este repositorio contiene la entrega del taller: una API desarrollada con FastAPI que consulta una base de datos PostgreSQL y un reverse-proxy Nginx delante de la API. En este documento explico cómo ejecutar el proyecto, cómo verificar los endpoints, cómo hacer backup/restore y las decisiones de diseño relevantes.

Estructura del proyecto

- `api/` — Código de la API (FastAPI) y `Dockerfile` (multi-stage).
- `db/` — Dockerfile del servicio Postgres, `seed.sql` y scripts de utilidad.
- `reverse-proxy/` — Configuración de Nginx.
- `docker-compose.yml` — Orquesta los servicios, redes y volúmenes.
- `.env.example` — Variables de entorno de ejemplo.
- `Makefile` — Comandos para tareas comunes.

Requisitos previos

- Docker Desktop/Engine con Compose v2
- Git
- (Opcional) `make` o PowerShell en Windows

1) Instrucciones para ejecutar el taller

a) Preparar variables de entorno

Copie el ejemplo y edite si desea cambiar credenciales o puertos:

```powershell
Copy-Item catalogo\.env.example catalogo\.env
```

b) Levantar los servicios

```powershell
cd catalogo
docker compose up -d --build
```

c) Comprobar que todo está arriba

```powershell
docker compose ps
docker compose logs --timestamps
```

2) Endpoints y pruebas básicas

- Health check (expuesto por Nginx):

```powershell
curl http://localhost:8080/health
```

- Listado de items (desde Postgres):

```powershell
curl http://localhost:8080/items | ConvertFrom-Json
```

El endpoint `/items` devuelve un objeto JSON con la lista de productos. Para evidenciar balanceo (si escala la API) este endpoint incluye el identificador de la instancia que respondió (`instance`).

3) Escalamiento y observación de balanceo

- Escalar la API a 2 réplicas:

```powershell
docker compose up -d --scale api=2
```

- Hacer varias peticiones y observar alternancia (PowerShell):

```powershell
for ($i=0; $i -lt 10; $i++) { curl http://localhost:8080/items | ConvertFrom-Json | select -ExpandProperty instance; Start-Sleep -Milliseconds 200 }
```

Si ve distintos valores en `instance` significa que las peticiones están siendo atendidas por réplicas distintas.

4) Backup y restore

- Crear backup (desde la carpeta `catalogo`):

```powershell
docker compose exec db pg_dump -U $Env:POSTGRES_USER -d $Env:POSTGRES_DB > backup.sql
```

- Restaurar desde `backup.sql`:

```powershell
Get-Content .\\backup.sql -Raw | docker compose exec -T db psql -U $Env:POSTGRES_USER -d $Env:POSTGRES_DB
```

5) Nota sobre seeds y persistencia

La primera vez que se arranca Postgres el script `db/seed.sql` se ejecuta automáticamente. Si el volumen `pgdata` ya existe, los scripts de `docker-entrypoint-initdb.d` no se re-ejecutan. Para aplicar cambios de `seed.sql` sin perder datos, he hecho que `seed.sql` sea idempotente; puede aplicarlo manualmente con:

```powershell
Get-Content .\\db\\seed.sql -Raw | docker compose exec -T db psql -U $Env:POSTGRES_USER -d $Env:POSTGRES_DB
```

Si prefiere reiniciar desde cero (pérdida de datos en el volumen):

```powershell
docker compose down -v
docker compose up -d --build
```

6) Notas de diseño (resumen)

- API
  - FastAPI con Uvicorn.
  - `Dockerfile` multi-stage: build ligero y ejecución en runtime mínimo.
  - Se ejecuta con un usuario no root en la imagen final.
  - Variables de configuración: `POSTGRES_HOST`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`, `POSTGRES_PORT`.

- Base de datos
  - Postgres oficial (15-alpine) con volumen `pgdata` para persistencia.
  - `seed.sql` en `/docker-entrypoint-initdb.d/` y healthcheck (`pg_isready`).

- Reverse-proxy
  - Nginx expone solo el puerto `8080` al host.
  - Cabeceras de seguridad añadidas: `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`.
  - Configuración ajustada para re-resolución DNS y permitir round-robin entre réplicas.

- Orquestación
  - `docker-compose.yml` define dos redes (backend interno y edge), volúmenes y `depends_on` con condición `service_healthy` para que la API espere a la DB.

7) Cómo documentar evidencias (para la evaluación)

- Captura de `docker compose ps` mostrando servicios y réplicas.
- Fragmentos de logs donde se vean los healthchecks OK (`docker compose logs --timestamps`).
- Salida de `curl http://localhost:8080/items` antes y después de bajar/subir los contenedores para mostrar persistencia.
- Salida de las peticiones a `/items` tras escalar a 2 réplicas, mostrando alternancia en `instance`.
- Archivo `backup.sql` generado por el comando de backup.

8) Comandos útiles (resumen rápido)

```powershell
# Levantar
docker compose up -d --build

# Bajar
docker compose down

# Escalar API
docker compose up -d --scale api=2

# Backup
docker compose exec db pg_dump -U $Env:POSTGRES_USER -d $Env:POSTGRES_DB > backup.sql

# Restore
Get-Content .\\backup.sql -Raw | docker compose exec -T db psql -U $Env:POSTGRES_USER -d $Env:POSTGRES_DB

# Ver servicios
docker compose ps

# Logs
docker compose logs --timestamps
```

---

Autor: Melanie Seguel Orellana
Fecha: 13 de Noviembre del 2025