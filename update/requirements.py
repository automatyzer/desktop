import re
import subprocess
import shutil

def update_requirements():
    # Create a backup of the original requirements file
    shutil.copy('requirements.txt', 'requirements.txt.backup')

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

    # Upgrade pip
    subprocess.run(['pip', 'install', '--upgrade', 'pip'], check=True)

    # Upgrade all packages
    subprocess.run(['pip', 'install', '--upgrade', '-r', 'requirements.txt'], check=True)

    print("Packages have been updated and version constraints removed.")

if __name__ == '__main__':
    update_requirements()