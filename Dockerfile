# GCP Cloud Run deployment Dockerfile for n8n
FROM node:22-alpine

# Install dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    sqlite

# Set working directory
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm@10.12.1

# Copy package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages ./packages
COPY patches ./patches
COPY scripts ./scripts
COPY tsconfig.json ./
COPY turbo.json ./
COPY biome.jsonc ./

# Install dependencies and build
RUN pnpm install --frozen-lockfile
RUN pnpm build

# Expose port (Cloud Run uses PORT environment variable)
EXPOSE 8080

# Set environment variables for Cloud Run
ENV NODE_ENV=production
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=${PORT:-8080}
ENV N8N_PROTOCOL=https
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
ENV DB_TYPE=sqlite
ENV DB_SQLITE_DATABASE=/app/database.sqlite

# Create data directory
RUN mkdir -p /app/.n8n && chown -R node:node /app

# Switch to non-root user
USER node

# Start n8n
CMD ["pnpm", "start"]