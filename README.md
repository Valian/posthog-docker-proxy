# PostHog Nginx Reverse Proxy

A configurable nginx reverse proxy for PostHog that allows you to proxy requests to PostHog Cloud while maintaining security through referer header validation.

## Features

- 🔒 **Security**: Validates referer headers to ensure requests only come from your domain
- 🌍 **Multi-region support**: Configure for US or EU PostHog Cloud
- ⚙️ **Environment-based configuration**: All settings configurable via environment variables
- 🐳 **Docker-ready**: Simple Docker container with sensible defaults

## Environment Variables

| Variable | Default | Required | Description |
|----------|---------|----------|-------------|
| `NGINX_PORT` | `8080` | No | Port on which nginx will listen |
| `DOMAIN` | - | **Yes** | Your domain for referer validation (without protocol) |
| `POSTHOG_REGION` | `us` | No | PostHog region (`us` or `eu`) |

## Quick Start

### Using Docker Hub Image (Recommended)

```bash
# Run with required DOMAIN
docker run -p 8080:8080 -e DOMAIN=myapp.com valian/posthog-nginx-proxy:latest

# Run with specific version
docker run -p 8080:8080 -e DOMAIN=myapp.com valian/posthog-nginx-proxy:v1.0.0
```

### Building Locally

```bash
# Build the image
docker build -t posthog-nginx-proxy .

# Run with required DOMAIN (will fail without it)
docker run -p 8080:8080 -e DOMAIN=myapp.com posthog-nginx-proxy

# Run with custom configuration
docker run -p 8080:8080 \
  -e DOMAIN=myapp.com \
  -e POSTHOG_REGION=eu \
  -e NGINX_PORT=8080 \
  posthog-nginx-proxy
```

### Using Docker Compose

```yaml
version: '3.8'
services:
  posthog-proxy:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DOMAIN=myapp.com
      - POSTHOG_REGION=eu
      - NGINX_PORT=8080
```

## Configuration Examples

### US PostHog Cloud
```bash
docker run -p 8080:8080 \
  -e DOMAIN=myapp.com \
  -e POSTHOG_REGION=us \
  posthog-nginx-proxy
```

### EU PostHog Cloud
```bash
docker run -p 8080:8080 \
  -e DOMAIN=myapp.com \
  -e POSTHOG_REGION=eu \
  posthog-nginx-proxy
```

### Custom Port
```bash
docker run -p 9000:9000 \
  -e NGINX_PORT=9000 \
  -e DOMAIN=myapp.com \
  posthog-nginx-proxy
```

## PostHog Client Configuration

Once your proxy is running, configure your PostHog client to use the proxy URL:

### JavaScript
```javascript
import posthog from 'posthog-js'

posthog.init('<your-project-api-key>', {
  api_host: 'http://localhost:8080' // Your proxy URL
})
```

### Python
```python
import posthog

posthog.api_key = '<your-project-api-key>'
posthog.host = 'http://localhost:8080'  # Your proxy URL
```

## Security

This proxy includes referer header validation to ensure requests only come from your specified domain. The validation allows:

- `localhost` (for development)
- Any subdomain of your configured domain (e.g., `app.myapp.com`, `www.myapp.com`)

Requests from other domains will receive a 403 Forbidden response.

## How It Works

1. **Request Validation**: Checks the `Referer` header to ensure requests come from your domain
2. **Static Assets**: Proxies `/static/*` requests to PostHog's asset servers
3. **API Requests**: Proxies all other requests to PostHog's main API
4. **DNS Resolution**: Uses Google Public DNS for reliable name resolution

## Development

### Building Locally
```bash
docker build -t posthog-nginx-proxy .
```

### Testing
```bash
# Start the proxy (DOMAIN is required)
docker run -p 8080:8080 -e DOMAIN=localhost posthog-nginx-proxy

# Test with curl
curl -H "Referer: http://localhost:8080" http://localhost:8080/capture
```

## Troubleshooting

### Common Issues

1. **403 Forbidden**: Check that your domain is correctly configured and the referer header is being sent
2. **Connection refused**: Ensure the port is correctly exposed and not blocked by firewall
3. **DNS resolution issues**: The proxy uses Google Public DNS (8.8.8.8) by default

### Debug Mode
To see nginx logs:
```bash
docker run -p 8080:8080 -e DOMAIN=myapp.com posthog-nginx-proxy
```

## License

This project is based on the [PostHog nginx proxy documentation](https://posthog.com/docs/advanced/proxy/nginx) and is provided as-is for educational and development purposes.

## Releases

This project uses semantic versioning. When a new tag is pushed to GitHub, it automatically:

1. Builds the Docker image
2. Pushes to Docker Hub as `valian/posthog-nginx-proxy:latest` and `valian/posthog-nginx-proxy:vX.Y.Z`
3. Creates a GitHub release

### Available Docker Images

- `valian/posthog-nginx-proxy:latest` - Latest stable release
- `valian/posthog-nginx-proxy:vX.Y.Z` - Specific version (e.g., `v1.0.0`)

## Contributing

Feel free to open issues or submit pull requests for improvements!