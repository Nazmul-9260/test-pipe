#!/bin/sh

set -e

echo "Waiting for database connection..."
until nc -z -v -w30 db 3306; do
  echo "Waiting for database..."
  sleep 5
done
echo "Database is up!"

if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.main..."
    cp .env.main .env
fi

if ! grep -q "APP_KEY=base64" .env; then
    echo "Generating application key..."
    php artisan key:generate
fi

echo "Running migrations..."
php artisan migrate --force

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

exec "$@"
