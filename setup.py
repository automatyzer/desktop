from setuptools import setup, find_packages

setup(
    name="automatyzer",
    version="0.1.28",
    description="Print from html to pdf, zpl, image, printer: html to print, htmlautomatyzer, html to pdf,html2pdf, pdf to print, pdfautomatyzer, zpl to print,zplautomatyzer, image to print,  imageautomatyzer, ",
    author="Tom Softreck",
    author_email="info@softreck.dev",
    url="https://github.com/automatyzer/automatyzer",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
    ],
    python_requires=">=3.7",
)
