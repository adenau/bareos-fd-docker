#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Default config directory and data directory
CONFIG_DIR=${CONFIG_DIR:-/etc/bareos}
DATA_DIR=${DATA_DIR:-/data}

# Ensure the config directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Configuration directory $CONFIG_DIR not found. Exiting."
    exit 1
fi

# Ensure the data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo "Data directory $DATA_DIR not found. Creating it..."
    mkdir -p "$DATA_DIR"
fi

# Start the Bareos File Daemon
echo "Starting Bareos File Daemon..."
exec bareos-fd -c "$CONFIG_DIR/bareos-fd.conf"