from fastapi import FastAPI, HTTPException, Response
from pydantic import BaseModel
import os
import psycopg2
from psycopg2.extras import RealDictCursor
import socket

app = FastAPI()

# Configuración de la base de datos
DB_HOST = os.getenv("POSTGRES_HOST", "db")
DB_USER = os.getenv("POSTGRES_USER", "catalog_user")
DB_PASS = os.getenv("POSTGRES_PASSWORD", "change_me_in_production")
DB_NAME = os.getenv("POSTGRES_DB", "catalog_db")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            port=DB_PORT,
            cursor_factory=RealDictCursor
        )
        return conn
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.get("/items")
async def get_items():
    # Identificador de la instancia para evidenciar balanceo
    hostname = os.getenv("HOSTNAME") or socket.gethostname()

    conn = get_db_connection()
    try:
        cur = conn.cursor()
        cur.execute("SELECT * FROM items")
        items = cur.fetchall()
        cur.close()
        # Devolvemos el hostname en la respuesta y en una cabecera X-Instance
        return {"items": items, "instance": hostname}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()