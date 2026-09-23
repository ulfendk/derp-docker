# derp-docker

Container image for the Tailscale DERP relay (`derper`), built from the latest stable Tailscale release.

- Image: `ghcr.io/ulfendk/derper`
- Tags: `latest`, the Tailscale version (e.g. `1.102.4`), and `sha-<short>`
- Platform: `linux/amd64`

The image only sets `ENTRYPOINT ["derper"]`; pass all flags via `command:`.

## Updates

A GitHub Actions workflow builds on every push to `main` and on manual dispatch (with an optional force flag). A weekly scheduled run resolves the latest `tailscale/tailscale` release and builds only if `ghcr.io/ulfendk/derper:<version>` doesn't exist yet.

## Example

Behind a TLS-terminating reverse proxy, with `-verify-clients` using tailscaled's socket (the container runs as root to read it):

```yaml
  derper:
    image: ghcr.io/ulfendk/derper:latest
    container_name: derper
    network_mode: host
    command:
      - -a=:8080
      - -http-port=-1
      - -stun=true
      - -stun-port=3478
      - -hostname=derp.example.com
      - -verify-clients=true
    volumes:
      - tailscale-socket:/var/run/tailscale
    restart: unless-stopped
```

## Portainer stack

[`docker-compose.yml`](docker-compose.yml) is a complete stack (tailscale + derper) ready to paste into Portainer. Set `TS_AUTHKEY`, `TS_ROUTES` (e.g. `192.0.2.0/24`) and `DERP_HOSTNAME` (e.g. `derp.example.com`) as stack environment variables. If the GHCR package is private, add a GHCR registry in Portainer; otherwise set the package visibility to public.
