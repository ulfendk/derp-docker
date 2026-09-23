FROM golang:alpine AS builder
ARG DERPER_VERSION=latest
RUN CGO_ENABLED=0 go install -trimpath -ldflags="-s -w" tailscale.com/cmd/derper@${DERPER_VERSION}

FROM alpine:latest
ARG DERPER_VERSION=latest
LABEL org.opencontainers.image.source="https://github.com/ulfendk/derp-docker" \
      org.opencontainers.image.description="Tailscale DERP relay server (derper)" \
      org.opencontainers.image.version="${DERPER_VERSION}"
RUN apk add --no-cache ca-certificates
COPY --from=builder /go/bin/derper /usr/local/bin/derper
ENTRYPOINT ["derper"]
