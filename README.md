

# PocketBase Docker Image

[![Docker Image Version](https://img.shields.io/docker/v/mussingtonr/pocketbase?sort=semver&label=version&style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/mussingtonr/pocketbase)
[![PocketBase Version](https://img.shields.io/badge/pocketbase-v0.30.1-blue?style=for-the-badge&logo=pocketbase&logoColor=white)](https://github.com/pocketbase/pocketbase)
[![Docker Image Size](https://img.shields.io/docker/image-size/mussingtonr/pocketbase/latest?label=image%20size&style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/mussingtonr/pocketbase)
[![Docker Pulls](https://img.shields.io/docker/pulls/mussingtonr/pocketbase?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/mussingtonr/pocketbase)
[![GitHub](https://img.shields.io/github/license/mussingtonr/pocketbase-docker-dokploy-template?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mussingtonr/pocketbase-docker-dokploy-template)

I've created this auto-updating Docker image for [PocketBase](https://pocketbase.io). The image is specifically designed for [Dokploy](https://dokploy.com) deployments, as the current Dokploy templates for PocketBase weren't meeting my needs.

Pulling `mussingtonr/pocketbase:latest` will automatically retrieve the correct image for your architecture.

## Supported Architectures

This image supports multiple architectures, so you can run it on various platforms:

- `linux/amd64` - x86-64 
- `linux/arm64` - ARM64
- `linux/arm/v7` - ARMv7

## What is PocketBase?

This Docker image is a build of [pocketbase.io](https://pocketbase.io) - Open Source backend for your next SaaS and Mobile app in 1 file.

## Application Setup

Access the web UI at `<your-ip>:80`, for more information check out [PocketBase](https://pocketbase.io).

## Volume Directories

I've configured the image to support multiple directories that are mounted into the container. These folders are mapped to the root inside the container:

- **pb_data** (Required) - Holds your application config and data. This should be mapped to your local file system to persist them!
- **pb_public** (Optional) - Used for serving static files. Supported in PocketBase since version 0.20.7
- **pb_migrations** (Optional) - Allows you to version your DB structure. See https://pocketbase.io/docs/js-migrations/. Supported in PocketBase since version 0.20.8
- **pb_hooks** (Optional) - Allows you to add custom JavaScript hooks for extending functionality. See https://pocketbase.io/docs/js-overview/

## Environment Variables

I've added support for several environment variables to make the image more configurable:

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `POCKETBASE_ADMIN_EMAIL` | Admin user email. When set with password, automatically creates or updates the admin user on startup | Optional | - |
| `POCKETBASE_ADMIN_PASSWORD` | Admin user password | Optional | - |
| `POCKETBASE_ENCRYPTION_KEY` | Encrypts application settings in the database (OAuth2 secrets, SMTP passwords, etc.) | Optional | - |
| `POCKETBASE_PORT` | Server port number | Optional | `80` |
| `POCKETBASE_DATA_DIR` | Data directory path | Optional | `/pb_data` |
| `POCKETBASE_PUBLIC_DIR` | Static files directory path | Optional | `/pb_public` |
| `POCKETBASE_MIGRATIONS_DIR` | Migrations directory path | Optional | `/pb_migrations` |
| `POCKETBASE_HOOKS_DIR` | Hooks directory path | Optional | `/pb_hooks` |

# Usage

### Standard Deployment

I've included a basic [`docker-compose.yml`](https://github.com/mussingtonr/pocketbase-docker-dokploy-template/blob/main/docker-compose.example.yml) file for standard deployments:

```yaml
services:
  pocketbase:
    image: mussingtonr/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - /path/to/data:/pb_data
      - /path/to/public:/pb_public        # Optional
      - /path/to/migrations:/pb_migrations # Optional
      - /path/to/hooks:/pb_hooks          # Optional
    environment:
      - TZ=America/New_York
      # Optional: Uncomment to auto-create admin user
      # - POCKETBASE_ADMIN_EMAIL=admin@example.com
      # - POCKETBASE_ADMIN_PASSWORD=your-secure-password
      # Optional: Uncomment to encrypt sensitive settings
      # - POCKETBASE_ENCRYPTION_KEY=your-32-character-key
```

## Dokploy Deployment

I've created a dedicated [`docker-compose.dokploy.yml`](https://github.com/mussingtonr/pocketbase-docker-dokploy-template/blob/main/docker-compose.dokploy.yml) template specifically for Dokploy deployments. This template uses Dokploy's standard volume path structure.

```yaml
services:
  pocketbase:
    image: mussingtonr/pocketbase:latest
    restart: unless-stopped
    volumes:
      - ../files/pb_data:/pb_data
      - ../files/pb_public:/pb_public
      - ../files/pb_migrations:/pb_migrations
      - ../files/pb_hooks:/pb_hooks
    environment:
      # Timezone configuration
      - TZ=America/New_York
      
      # Optional: Admin user credentials
      # Uncomment and set these to automatically create/update an admin user
      # - POCKETBASE_ADMIN_EMAIL=admin@example.com
      # - POCKETBASE_ADMIN_PASSWORD=your-secure-password-here
      
      # Optional: Encryption key for securing settings in the database
      # Generate a secure random key: openssl rand -base64 32
      # - POCKETBASE_ENCRYPTION_KEY=your-encryption-key-here
```

## Updates

The Docker image is automatically built daily via GitHub Actions. It always contains the latest PocketBase version. You don't need to manually check for updates - just pull the latest image.

## Reference Links

- [PocketBase GitHub](https://github.com/pocketbase/pocketbase)
- [PocketBase Website](https://pocketbase.io)
- [PocketBase Documentation](https://pocketbase.io/docs/)
- [Docker Hub Repository](https://hub.docker.com/r/mussingtonr/pocketbase)
- [GitHub Repository](https://github.com/mussingtonr/pocketbase-docker-dokploy-template)

## License

This Docker image configuration is provided as-is. PocketBase itself is licensed under the MIT License.
