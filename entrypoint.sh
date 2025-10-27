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

# Create admin user if credentials are provided
if [ -n "$POCKETBASE_ADMIN_EMAIL" ] && [ -n "$POCKETBASE_ADMIN_PASSWORD" ]; then
    echo "Admin credentials provided, will create/update admin user..."
    
    # Start PocketBase in background to create admin
    $CMD &
    PB_PID=$!
    
    # Wait for PocketBase to start (check if port is listening)
    echo "Waiting for PocketBase to start..."
    for i in $(seq 1 30); do
        if nc -z localhost ${POCKETBASE_PORT} 2>/dev/null; then
            echo "PocketBase started, creating/updating admin user..."
            break
        fi
        if [ $i -eq 30 ]; then
            echo "Timeout waiting for PocketBase to start"
            kill $PB_PID 2>/dev/null || true
            exit 1
        fi
        sleep 1
    done
    
    # Create or update admin user using the superuser command (PocketBase 0.9+)
    /usr/local/bin/pocketbase superuser create "$POCKETBASE_ADMIN_EMAIL" "$POCKETBASE_ADMIN_PASSWORD" \
        --dir="${POCKETBASE_DATA_DIR}" 2>/dev/null || \
    /usr/local/bin/pocketbase superuser update "$POCKETBASE_ADMIN_EMAIL" "$POCKETBASE_ADMIN_PASSWORD" \
        --dir="${POCKETBASE_DATA_DIR}" || true
    
    echo "Admin user setup complete"
    
    # Stop the background process
    kill $PB_PID 2>/dev/null || true
    wait $PB_PID 2>/dev/null || true
    
    # Small delay to ensure clean shutdown
    sleep 2
fi

# Start PocketBase normally
echo "Starting PocketBase..."
exec $CMD