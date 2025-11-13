#!/bin/bash
set -e

host="$1"
user="$2"
db="$3"
export PGPASSWORD="$4"

until pg_isready -h "$host" -p 5432 -U "$user" -d "$db"; do
  echo >&2 "Postgres is unavailable - sleeping"
  sleep 1
done

echo >&2 "Postgres is up - executing command"