# docker-archipelago-client

This is a Docker container for [Archipelago](https://github.com/ArchipelagoMW/Archipelago), built on top of the LinuxServer Selkies desktop base image. The purpose is to have a server-based client image since the official web app does not provide the full functionality. This will allow you to access it from a dedicated machine to build YAMLs, install AP Worlds, and host all without having to use temporary port fowarding on a dynamic client.

The app is exposed in a GUI on `8080` (HTTP) and `8181` (HTTPS)


## Building

Use the repository `Dockerfile` to build the x86_64 image.

```bash
docker build \
  --build-arg BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --build-arg VERSION="X.Y.Z" \
  --build-arg ARCHIPELAGO_RELEASE="latest" \
  -t docker-archipelago-client:latest .
```

To pin a specific Archipelago release, set `ARCHIPELAGO_RELEASE` to a valid tag name:

```bash
docker build \
  --build-arg ARCHIPELAGO_RELEASE="v0.6.7" \
  -t docker-archipelago-client:0.6.7 .
```

## Run

Run the container with a persistent config volume and ports mapped:

```bash
docker run -d \
  --name archipelago-client \
  -p 8080:8080 \
  -p 8181:8181 \
  -p 38281:38281 \
  -v /path/to/config:/config \
  docker-archipelago-client:latest
```

Then open one of these URLs in your browser:

- `http://localhost:8080`
- `https://localhost:8181`

## Configuration

The container supports a small set of environment variables used by the base Selkies image and the Archipelago client launch.

| Variable | Default | Description |
| --- | --- | --- |
| `ARCHIPELAGO_RELEASE` | `latest` | AppImage release tag to download from GitHub |
| `CUSTOM_PORT` | `8080` | HTTP port used by the container |
| `CUSTOM_HTTPS_PORT` | `8181` | HTTPS port used by the container |
| `TITLE` | `Archipelago` | Browser window title for the desktop session |


## Volumes

Mount a host directory to `/config` to preserve Archipelago settings and saves:

```bash
-v /path/to/config:/config
```

## Supported architectures

Only `x86_64` is supported due to an official arm64 Linux release.

## Notes

- The Archipelago AppImage is downloaded during build time. This means the runtime container does not need to fetch the AppImage again after startup.
- If you want to use a reverse proxy, map the container ports and forward them to your proxy endpoint.
- The container exposes an internal healthcheck on port `8080`.

## Upstream

This project is based on the official Archipelago project:

- GitHub: https://github.com/ArchipelagoMW/Archipelago
- Website: https://archipelago.gg
- Documentation: https://archipelago.gg/tutorial/
- Community: https://discord.gg/archipelago

## License

This repository ships under the same license as its root project and is compatible with the upstream Archipelago license. See `LICENSE` for details.

## Acknowledgements

Thanks to the Archipelago upstream project!
