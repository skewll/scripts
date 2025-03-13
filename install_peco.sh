#!/bin/bash

# Set variables
VERSION="v0.5.3"
ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
INSTALL_DIR="/usr/local/bin"

# Determine architecture and set URL
case "$ARCH" in
    x86_64|amd64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    armv7l)
        ARCH="arm"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

URL="https://github.com/peco/peco/releases/download/$VERSION/peco_${OS}_${ARCH}.tar.gz"

# Check if peco is already installed
if command -v peco &> /dev/null; then
    INSTALLED_VERSION=$(peco --version | awk '{print $2}')
    if [[ "$INSTALLED_VERSION" == "$VERSION" ]]; then
        echo "Peco $VERSION is already installed."
        exit 0
    else
        echo "Updating Peco from $INSTALLED_VERSION to $VERSION..."
    fi
fi

# Download and extract
echo "Downloading Peco $VERSION for $ARCH architecture..."
curl -sL "$URL" -o peco.tar.gz

# Extract the file without checking file type
echo "Extracting files..."
tar -xvzf peco.tar.gz
rm peco.tar.gz

# Move binary to /usr/local/bin
echo "Installing to $INSTALL_DIR..."
sudo mv peco_${OS}_${ARCH}/peco "$INSTALL_DIR/peco"
sudo chmod +x "$INSTALL_DIR/peco"

# Clean up
rm -rf peco_${OS}_${ARCH}

# Verify installation
echo "Peco installed successfully!"
peco --version