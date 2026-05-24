# apps/api/Dockerfile

# ─── Stage 1: Base (shared by dev and prod) ───────────────────
FROM node:20-alpine AS base
WORKDIR /app

# Copy package files first (Docker layer caching)
# If package.json doesn't change, this layer is cached — much faster rebuilds
COPY package*.json ./
COPY prisma ./prisma/

# ─── Stage 2: Development ─────────────────────────────────────
FROM base AS development
# Install ALL dependencies (including devDependencies like ts-node, jest)
RUN npm ci

COPY . .
# Generate Prisma client
RUN npx prisma generate

EXPOSE 3000
# ts-node-dev: TypeScript hot-reload in development
CMD ["npm", "run", "start:dev"]

# ─── Stage 3: Build ────────────────────────────────────────────
FROM base AS build
RUN npm ci --only=production
COPY . .
RUN npx prisma generate
# Compile TypeScript to JavaScript
RUN npm run build

# ─── Stage 4: Production ──────────────────────────────────────
FROM node:20-alpine AS production
# Create non-root user (security: never run production as root)
RUN addgroup -g 1001 -S nodejs && adduser -S nestjs -u 1001
WORKDIR /app

# Copy only what's needed (keeps image small)
COPY --from=build --chown=nestjs:nodejs /app/dist ./dist
COPY --from=build --chown=nestjs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nestjs:nodejs /app/prisma ./prisma

USER nestjs
EXPOSE 3000
CMD ["node", "dist/main"]