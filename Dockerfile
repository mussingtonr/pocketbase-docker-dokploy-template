FROM alpine:3 as downloader

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV BUILDX_ARCH="${TARGETOS:-linux}_${TARGETARCH:-amd64}${TARGETVARIANT}"

# Install dependencies for fetching the latest version
RUN apk add --no-cache curl jq

# Fetch the latest PocketBase version from GitHub API and download it
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/pocketbase/pocketbase/releases/latest | jq -r '.tag_name' | sed 's/v//') && \
    echo "Downloading PocketBase version: ${LATEST_VERSION}" && \
    wget https://github.com/pocketbase/pocketbase/releases/download/v${LATEST_VERSION}/pocketbase_${LATEST_VERSION}_${BUILDX_ARCH}.zip && \
    unzip pocketbase_${LATEST_VERSION}_${BUILDX_ARCH}.zip && \
    chmod +x /pocketbase

FROM alpine:3
RUN apk update && apk add ca-certificates netcat-openbsd && rm -rf /var/cache/apk/*

EXPOSE 80

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]