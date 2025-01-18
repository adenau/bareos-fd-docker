#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Default configuration file paths
CONFIG_DIR=/etc/bareos/bareos-fd.d
DIRECTOR_CONF=$CONFIG_DIR/director/bareos-dir.conf
CLIENT_CONF=$CONFIG_DIR/client/myself.conf

# Validate required environment variables
if [ -z "$BAREOS_DIR_HOSTNAME" ] || [ -z "$BAREOS_DIR_PASSWORD" ] || \
   [ -z "$BAREOS_DIR_ADDRESS" ] || [ -z "$BAREOS_CLIENT_NAME" ]; then
  echo "ERROR: Missing one or more required environment variables."
  echo "Ensure BAREOS_DIR_HOSTNAME, BAREOS_DIR_PASSWORD, BAREOS_DIR_ADDRESS, and BAREOS_CLIENT_NAME are set."
  exit 1
fi

# Generate the director configuration file
mkdir -p "$(dirname "$DIRECTOR_CONF")"
echo "Generating $DIRECTOR_CONF..."
cat > "$DIRECTOR_CONF" <<EOF
Director {
  Name = $BAREOS_DIR_HOSTNAME
  Address = $BAREOS_DIR_ADDRESS
  Password = $BAREOS_DIR_PASSWORD
EOF

# Append additional director parameters if specified
if [ -n "$BAREOS_DIR_ADDITIONAL_PARAMS" ]; then
  echo "$BAREOS_DIR_ADDITIONAL_PARAMS" >> "$DIRECTOR_CONF"
fi

# Close the Director block
echo "}" >> "$DIRECTOR_CONF"

# Generate the client configuration file
mkdir -p "$(dirname "$CLIENT_CONF")"
echo "Generating $CLIENT_CONF..."
cat > "$CLIENT_CONF" <<EOF
Client {
  Name = $BAREOS_CLIENT_NAME

  TLS Enable = yes
EOF

# Append additional client parameters if specified
if [ -n "$BAREOS_CLIENT_ADDITIONAL_PARAMS" ]; then
  echo "$BAREOS_CLIENT_ADDITIONAL_PARAMS" >> "$CLIENT_CONF"
fi

# Close the Client block
echo "}" >> "$CLIENT_CONF"

# Start the Bareos File Daemon
echo "Starting Bareos File Daemon..."
exec bareos-fd -f
