# Start with a base image
FROM debian:bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install prerequisites for Bareos repository setup
RUN apt-get update && \
    apt-get install -y \
    wget \
    gnupg \
    apt-transport-https && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the Bareos repository and install Bareos
RUN wget https://download.bareos.org/current/Debian_12/add_bareos_repositories.sh && \
    chmod +x add_bareos_repositories.sh && \
    ./add_bareos_repositories.sh && \
    apt-get update && \
    apt-get install -y bareos-filedaemon && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose Bareos ports
EXPOSE 9102

# Add entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Create directories for configuration and data
VOLUME ["/etc/bareos", "/data"]

# Environment variables for configuration
ENV BAREOS_DIR_HOSTNAME="" \
    BAREOS_DIR_PASSWORD="" \
    BAREOS_DIR_ADDRESS="" \
    BAREOS_CLIENT_NAME="" \
    BAREOS_DIR_ADDITIONAL_PARAMS="" \
    BAREOS_CLIENT_ADDITIONAL_PARAMS=""

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
