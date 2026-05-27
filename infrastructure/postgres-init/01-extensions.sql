-- infrastructure/postgres-init/01-extensions.sql
-- This runs automatically when the container first starts
-- It runs as the postgres superuser, so it can create extensions

CREATE EXTENSION IF NOT EXISTS vector;

-- Grant superuser to notifyx so Prisma's shadow database can also create extensions
ALTER USER notifyx SUPERUSER;