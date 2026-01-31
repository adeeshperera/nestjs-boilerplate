#!/bin/sh
set -e

echo "🚀 Starting application initialization..."

# Run Prisma migrations (will create database if it doesn't exist)
echo "🔄 Running database migrations..."
npx prisma migrate deploy

echo "✅ Migrations completed successfully"

# Run database seed (optional - skip if seed file doesn't exist)
if [ -f "prisma/seed.ts" ]; then
  echo "🌱 Running database seed..."
  npx ts-node --transpile-only prisma/seed.ts || echo "⚠️ Seed skipped or already applied"
  echo "✅ Database seeding completed"
fi

# Start the application
echo "🚀 Starting application..."
exec dumb-init node dist/src/main.js