#!/bin/sh
set -e

# Default values
POCKETBASE_PORT="${POCKETBASE_PORT:-8090}"
POCKETBASE_DATA_DIR="${POCKETBASE_DATA_DIR:-/pb_data}"
POCKETBASE_PUBLIC_DIR="${POCKETBASE_PUBLIC_DIR:-/pb_public}"
POCKETBASE_MIGRATIONS_DIR="${POCKETBASE_MIGRATIONS_DIR:-/pb_migrations}"
POCKETBASE_HOOKS_DIR="${POCKETBASE_HOOKS_DIR:-/pb_hooks}"

# Build PocketBase command
CMD="/usr/local/bin/pocketbase serve"
CMD="$CMD --http=0.0.0.0:${POCKETBASE_PORT}"
CMD="$CMD --dir=${POCKETBASE_DATA_DIR}"
CMD="$CMD --publicDir=${POCKETBASE_PUBLIC_DIR}"
CMD="$CMD --migrationsDir=${POCKETBASE_MIGRATIONS_DIR}"
CMD="$CMD --hooksDir=${POCKETBASE_HOOKS_DIR}"

# Add encryption key if provided
if [ -n "$POCKETBASE_ENCRYPTION_KEY" ]; then
    CMD="$CMD --encryptionEnv=POCKETBASE_ENCRYPTION_KEY"
fi

# Wait for data directory to be available
mkdir -p "${POCKETBASE_DATA_DIR}"

# Create admin user if credentials are provided (before starting the server)
if [ -n "$POCKETBASE_ADMIN_EMAIL" ] && [ -n "$POCKETBASE_ADMIN_PASSWORD" ]; then
    echo "Admin credentials provided, setting up admin user..."
    
    # Use the superuser upsert command which works without the server running
    # This will create or update the superuser
    /usr/local/bin/pocketbase superuser upsert "$POCKETBASE_ADMIN_EMAIL" "$POCKETBASE_ADMIN_PASSWORD" \
        --dir="${POCKETBASE_DATA_DIR}" 2>&1 || true
    
    echo "Admin user setup complete"
fi

# Start PocketBase normally
echo "Starting PocketBase..."
exec $CMD