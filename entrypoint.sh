#!/bin/sh

# Set default values if not provided
export NGINX_PORT=${NGINX_PORT:-8080}
export POSTHOG_REGION=${POSTHOG_REGION:-us}

# Check if DOMAIN is defined
if [ -z "$DOMAIN" ]; then
    echo "ERROR: DOMAIN environment variable is required but not set."
    echo "Please set DOMAIN to your domain (e.g., myapp.com)"
    exit 1
fi

# Log the configuration
echo "Starting PostHog nginx proxy with configuration:"
echo "  - Domain: $DOMAIN"
echo "  - Port: $NGINX_PORT"
echo "  - PostHog Region: $POSTHOG_REGION"
echo ""

# Substitute environment variables in the nginx template
envsubst '${NGINX_PORT} ${DOMAIN} ${POSTHOG_REGION}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start nginx
exec nginx -g "daemon off;"