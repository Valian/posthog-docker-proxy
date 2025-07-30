FROM nginx:alpine

# Copy the template and entrypoint script
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose the default port
EXPOSE 8080

# Use the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]