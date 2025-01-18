# Bareos FD Docker

## Overview
This repository contains a Dockerized implementation of the Bareos File Daemon (FD). It provides a flexible and easy way to deploy and configure the Bareos FD, which is used for backup operations in the Bareos ecosystem. This container allows for dynamic configuration using environment variables, ensuring ease of deployment and customization.

## Why This Exists
Bareos FD is typically installed via package managers, but this approach might not always be feasible, especially in containerized environments. By using this repository, you can:

- Run Bareos FD in a portable, containerized manner.
- Dynamically configure it using environment variables.
- Avoid direct installation on host systems, keeping them clean and isolated.

## Features
- Dynamic configuration generation for `bareos-dir.conf` and `myself.conf`.
- Support for custom parameters using environment variables.
- TLS-enabled communication with the Bareos Director.

## How to Use

### Pull the Docker Image
Pull the prebuilt Docker image (replace `<username>` with your GitHub username):
```bash
docker pull ghcr.io/<username>/bareos-fd-docker:latest
```

### Run the Container
To run the container, supply the mandatory environment variables and any additional parameters as needed:
```bash
docker run -d \
  -e BAREOS_DIR_HOSTNAME="bareos-dir" \
  -e BAREOS_DIR_PASSWORD="mypassword" \
  -e BAREOS_DIR_ADDRESS="10.0.1.1" \
  -e BAREOS_CLIENT_NAME="my-client" \
  -e BAREOS_DIR_ADDITIONAL_PARAMS="Monitor = yes\nTLS Enable = yes" \
  -e BAREOS_CLIENT_ADDITIONAL_PARAMS="Heartbeat Interval = 60" \
  -v /path/to/config:/etc/bareos \
  -v /path/to/data:/data \
  ghcr.io/adenau/bareos-fd-docker:latest
```

### Mandatory Environment Variables
| Variable               | Description                                   | Example Value       |
|------------------------|-----------------------------------------------|---------------------|
| `BAREOS_DIR_HOSTNAME`  | The name of the Bareos Director              | `bareos-dir`         |
| `BAREOS_DIR_PASSWORD`  | The password for authentication with Director| `mypassword`         |
| `BAREOS_DIR_ADDRESS`   | The IP address or hostname of the Director   | `10.0.1.1`           |
| `BAREOS_CLIENT_NAME`   | The name of this client                      | `my-client`          |

### Optional Environment Variables
| Variable                      | Description                                    | Example Value                 |
|-------------------------------|------------------------------------------------|-------------------------------|
| `BAREOS_DIR_ADDITIONAL_PARAMS`| Additional parameters for `bareos-dir.conf`    | `Monitor = yes\nTLS Enable = yes`|
| `BAREOS_CLIENT_ADDITIONAL_PARAMS`| Additional parameters for `myself.conf`      | `Heartbeat Interval = 60`     |

## Configuration File Examples

### `bareos-dir.conf`
Generated dynamically from environment variables:
```text
Director {
  Name = bareos-dir
  Address = 10.0.1.1
  Password = mypassword
  Monitor = yes
  TLS Enable = yes
}
```

### `myself.conf`
Generated dynamically from environment variables:
```text
Client {
  Name = my-client

  TLS Enable = yes
  Heartbeat Interval = 60
}
```

## Volumes
| Mount Point      | Purpose                                 |
|------------------|-----------------------------------------|
| `/etc/bareos`    | Stores the Bareos FD configuration files|
| `/data`          | Directory for data to be backed up      |

## Development
To build the image locally:
```bash
docker build -t bareos-fd-docker .
```

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

