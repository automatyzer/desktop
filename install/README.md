# Desktop Automation Bot - Environment Setup Scripts

## Overview

These scripts automate the setup of the desktop automation bot environment on different Linux distributions.

## Prerequisites

- A Linux system (Ubuntu or Fedora)
- `sudo` access
- Internet connection

## Supported Distributions

- Ubuntu 20.04 and newer
- Fedora 33 and newer

## Usage

### Ubuntu

```bash
# Download the script
wget https://raw.githubusercontent.com/automatyzer/desktop-bot/main/ubuntu_setup.sh

# Make executable
chmod +x ubuntu_setup.sh

# Run with sudo
sudo bash ubuntu_setup.sh
```

### Fedora

```bash
# Download the script
wget https://raw.githubusercontent.com/automatyzer/desktop-bot/main/fedora_setup.sh

# Make executable
chmod +x fedora_setup.sh

# Run with sudo
sudo bash fedora_setup.sh
```

## What the Scripts Do

1. Update system packages
2. Install system dependencies
3. Install Python and virtual environment
4. Clone the desktop automation bot repository
5. Setup Python virtual environment
6. Install Python dependencies
7. Configure system for GUI automation

## Post-Installation

After running the script:
- The project is installed in `/opt/desktop-bot`
- A virtual environment is created
- Activate the environment with: 
  ```bash
  source /opt/desktop-bot/venv/bin/activate
  ```

## Troubleshooting

- Ensure you have `sudo` access
- Check internet connection
- Verify Python 3.8+ is installed
- If any dependency fails, you may need to install it manually

## Security Notes

- Review the script before running
- Only download from trusted sources
- The script requires root access, so use caution

## Customization

Modify the scripts to:
- Change installation directory
- Add/remove specific dependencies
- Adjust Python version

## Contributing

- Report issues on the GitHub repository
- Submit pull requests with improvements

## License

