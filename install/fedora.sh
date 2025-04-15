#!/bin/bash

# Fedora Environment Setup Script for Desktop Automation Bot

# Exit on any error
set -e

# Ensure script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo: sudo bash $0"
   exit 1
fi

# Update system packages
echo "Updating system packages..."
dnf update -y

# Install system dependencies
echo "Installing system dependencies..."
dnf install -y \
    python3 \
    python3-pip \
    python3-virtualenv \
    python3-tkinter \
    python3-devel \
    tesseract \
    tesseract-langpack-eng \
    mesa-libGL \
    libXxf86vm \
    libXtst \
    libXi \
    libXinerama \
    libXcursor \
    libxkbcommon \
    git \
    wget \
    scrot \
    libXrandr \
    libxcb \
    libxcb-cursor

# Install X11 and Wayland dependencies
dnf install -y \
    xorg-x11-server-Xvfb \
    libxcb-devel \
    libXi-devel

# Create project directory
PROJECT_DIR="/opt/desktop-bot"
mkdir -p "$PROJECT_DIR"

# Clone project (replace with actual repository URL)
echo "Cloning desktop automation bot repository..."
git clone https://github.com/automatyzer/desktop-bot.git "$PROJECT_DIR"

# Setup Python virtual environment
echo "Setting up Python virtual environment..."
cd "$PROJECT_DIR"
python3 -m venv venv
source venv/bin/activate

# Upgrade pip and setuptools
pip install --upgrade pip setuptools wheel

# Install Python dependencies
pip install -r requirements.txt

# Additional PyAutoGUI dependencies
pip install \
    pyautogui \
    paramiko \
    pytesseract \
    pillow \
    opencv-python

# Ensure Xvfb can run without issues
Xvfb :99 &
export DISPLAY=:99

# Set permissions
chown -R $(logname):$(logname) "$PROJECT_DIR"

# Cleanup
dnf clean all

echo "Desktop Automation Bot environment setup complete!"
echo "To activate the virtual environment, run: source $PROJECT_DIR/venv/bin/activate"

# Optional: Display Tesseract version to verify installation
tesseract --version