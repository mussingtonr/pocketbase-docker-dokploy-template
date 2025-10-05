# PocketBase Docker Image

[![Docker Image Version](https://img.shields.io/docker/v/mussingtonr/pocketbase?sort=semver&label=version)](https://hub.docker.com/r/mussingtonr/pocketbase)
[![Docker Image Size](https://img.shields.io/docker/image-size/mussingtonr/pocketbase/latest?label=image%20size)](https://hub.docker.com/r/mussingtonr/pocketbase)
[![Docker Pulls](https://img.shields.io/docker/pulls/mussingtonr/pocketbase)](https://hub.docker.com/r/mussingtonr/pocketbase)
[![GitHub](https://img.shields.io/github/license/mussingtonr/pocketbase-docker-dokploy-template)](https://github.com/mussingtonr/pocketbase-docker-dokploy-template)

**Docker version of PocketBase - backend for your next SaaS and Mobile App**

**Note:** This image was built with [Dokploy](https://dokploy.com) in mind. The current Dokploy images for PocketBase weren't serving my needs, so I built an image specifically designed to work seamlessly with Dokploy deployments.

## Supported Architectures

- `linux/amd64` - x86-64
- `linux/arm64` - ARM64
- `linux/arm/v7` - ARMv7

Pulling `mussingtonr/pocketbase:latest` will retrieve the correct image for your architecture.

## Application Setup

Access the webui at `<your-ip>:80`, for more information check out [PocketBase](https://pocketbase.io).

## pb_data, pb_public, pb_migrations, and pb_hooks

There are multiple configuration & files directories that are mounted into the container. These folders are mapped to the root inside container.

**pb_data** holds your application config and data and should be mapped to your local file system to persist them!

**pb_public** is optional, and is only used for serving static files. (supported in this docker image since version 0.20.7)

**pb_migrations** is optional, this directory allows you to version your DB structure. See [https://pocketbase.io/docs/js-migrations/](https://pocketbase.io/docs/js-migrations/). (supported in this docker image since version 0.20.8)

**pb_hooks** is optional, this directory allows you to add custom JavaScript hooks for extending functionality. See [https://pocketbase.io/docs/js-overview/](https://pocketbase.io/docs/js-overview/).

```yaml
volumes:
  - /path/to/data:/pb_data
  - /path/to/public:/pb_public
  - /path/to/migrations:/pb_migrations
  - /path/to/hooks:/pb_hooks
```

## PocketBase

This docker image is a build of [pocketbase.io](https://pocketbase.io) - Open Source backend for your next SaaS and Mobile app in 1 file

- Realtime database
- Authentication
- File storage
- Admin dashboard

## Environment Variables

The image supports several environment variables to customize PocketBase configuration:

### Admin User Configuration

- **POCKETBASE_ADMIN_EMAIL**: Admin user email address. When set along with password, automatically creates or updates the admin user on startup. No default.
- **POCKETBASE_ADMIN_PASSWORD**: Admin user password. No default.

Example:
```yaml
environment:
  - POCKETBASE_ADMIN_EMAIL=admin@example.com
  - POCKETBASE_ADMIN_PASSWORD=your-secure-password
```

## Dokploy Deployment

This image was specifically designed to work with [Dokploy](https://dokploy.com). A dedicated Dokploy template is provided.

### Using the Dokploy Template

1. In Dokploy, create a new Docker Compose service
2. Use the [`docker-compose.dokploy.yml`](docker-compose.dokploy.yml) template
3. The `${HASH}` variable will be automatically replaced by Dokploy with your service's unique identifier that you add in your environment variables
4. Configure environment variables as needed (admin credentials, encryption key, etc.)

The Dokploy template uses the standard Dokploy volume path structure:
```yaml
volumes:
  - /etc/dokploy/templates/${HASH}/data:/pb_data
  - /etc/dokploy/templates/${HASH}/public:/pb_public
  - /etc/dokploy/templates/${HASH}/migrations:/pb_migrations
  - /etc/dokploy/templates/${HASH}/hooks:/pb_hooks
```

This ensures all your PocketBase data is organized under a single hash-based directory in Dokploy's template storage.

### Encryption

- **POCKETBASE_ENCRYPTION_KEY**: Encrypts application settings in the database (OAuth2 secrets, SMTP passwords, etc.). Highly recommended for production. Generate with: `openssl rand -base64 32`. No default.

Example:
```yaml
environment:
  - POCKETBASE_ENCRYPTION_KEY=your-32-character-encryption-key
```

### Server Configuration

- **POCKETBASE_PORT**: Server port number. Default: `80`

Example:
```yaml
environment:
  - POCKETBASE_PORT=8090
ports:
  - "8090:8090"
```

### Directory Paths

- **POCKETBASE_DATA_DIR**: Data directory path. Default: `/pb_data`
- **POCKETBASE_PUBLIC_DIR**: Static files directory. Default: `/pb_public`
- **POCKETBASE_MIGRATIONS_DIR**: Migrations directory. Default: `/pb_migrations`
- **POCKETBASE_HOOKS_DIR**: Hooks directory. Default: `/pb_hooks`

**Note**: Only change these if you need custom internal paths. The volume mounts should match these paths.

### Complete Example

See [`docker-compose.example.yml`](docker-compose.example.yml) for a fully documented configuration template with all available options.

## Links

- [PocketBase GIT](https://github.com/pocketbase/pocketbase)
- [PocketBase WEB](https://pocketbase.io)
- [PocketBase DOCS](https://pocketbase.io/docs/)

## Usage

### docker-compose

```yaml
version: "3.7"
services:
  pocketbase:
    image: mussingtonr/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - /path/to/data:/pb_data
      - /path/to/public:/pb_public
      - /path/to/migrations:/pb_migrations
      - /path/to/hooks:/pb_hooks