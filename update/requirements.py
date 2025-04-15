import re
import subprocess
import shutil
import sys
import logging


def update_requirements():
    # Configure logging
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)

    # Create a backup of the original requirements file
    shutil.copy('requirements.txt', 'requirements.txt.backup')
    logger.info("Created backup of requirements.txt")

    # Read the original requirements file
    with open('requirements.txt', 'r') as f:
        requirements = f.readlines()

    # Remove version constraints
    updated_requirements = []
    for req in requirements:
        # Remove version specifiers
        cleaned_req = re.sub(r'[=<>]=?[0-9.]+', '', req.strip())
        if cleaned_req:
            updated_requirements.append(cleaned_req + '\n')

    # Write updated requirements
    with open('requirements.txt', 'w') as f:
        f.writelines(updated_requirements)
    logger.info("Removed version constraints")

    # Upgrade pip
    try:
        subprocess.run(['pip', 'install', '--upgrade', 'pip'],
                       check=True,
                       capture_output=True,
                       text=True)
        logger.info("Pip upgraded successfully")
    except subprocess.CalledProcessError as e:
        logger.error(f"Failed to upgrade pip: {e.stderr}")

    # Prepare to track failed packages
    failed_packages = []

    # Upgrade packages one by one to isolate problematic packages
    for package in updated_requirements:
        package = package.strip()
        if not package:
            continue

        try:
            result = subprocess.run(['pip', 'install', '--upgrade', package],
                                    check=True,
                                    capture_output=True,
                                    text=True)
            logger.info(f"Successfully upgraded {package}")
        except subprocess.CalledProcessError as e:
            logger.warning(f"Failed to upgrade {package}: {e.stderr}")
            failed_packages.append(package)

    # Print summary
    if failed_packages:
        logger.error("The following packages failed to upgrade:")
        for pkg in failed_packages:
            logger.error(pkg)

        # Optional: Write failed packages to a separate file
        with open('failed_upgrades.txt', 'w') as f:
            f.writelines(pkg + '\n' for pkg in failed_packages)

        logger.info("Failed packages have been written to failed_upgrades.txt")
        # Exit with error code to indicate partial failure
        sys.exit(1)
    else:
        logger.info("All packages upgraded successfully")


if __name__ == '__main__':
    update_requirements()