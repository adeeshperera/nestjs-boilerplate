FROM oven/bun:1-alpine AS deps
WORKDIR /app

# Copy package files
COPY package.json bun.lockb* ./

# Install dependencies
RUN bun install --frozen-lockfile

FROM oven/bun:1-alpine AS builder
WORKDIR /app

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy source code
COPY . .

# Generate Prisma client
RUN bunx prisma generate

# Generate JWT keys
RUN mkdir -p keys && \
    openssl ecparam -name prime256v1 -genkey -noout -out keys/private.pem && \
    openssl ec -in keys/private.pem -pubout -out keys/public.pem && \
    chmod 600 keys/private.pem && \
    chmod 644 keys/public.pem

# Build the application
RUN bun run build

# Install production dependencies only
RUN bun install --frozen-lockfile --production

FROM node:20-alpine AS runner
WORKDIR /app

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl dumb-init

# Create non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs

# Set environment
ENV NODE_ENV=production

# Copy built application
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./package.json
COPY --from=builder --chown=nodejs:nodejs /app/prisma ./prisma

# Copy JWT keys generated in builder stage
COPY --from=builder --chown=nodejs:nodejs /app/keys ./keys

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9000/health || exit 1

# Use dumb-init for proper signal handling
CMD ["dumb-init", "node", "dist/main.js"]
