#!/bin/sh
set -e

echo "Waiting for database connection..."
until nc -z -v -w30 db 3306; do
  echo "Waiting for database..."
  sleep 5
done
echo "Database is up!"

# Use .env.main instead of .env.example
if [ ! -f ".env" ]; then
    echo "Creating .env from .env.main..."
    cp .env.main .env
fi

# Generate app key if not present
if ! grep -q "APP_KEY=base64" .env; then
    echo "Generating app key..."
    php artisan key:generate
fi

echo "Running migrations..."
php artisan migrate --force

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

exec "$@"
