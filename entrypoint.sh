#!/bin/bash
until mysqladmin ping -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
  echo "Waiting for MySQL..."
  sleep 2
done
exec apache2-foreground
