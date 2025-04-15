# desktop-bot




## Quick Start

### Local Development
1. Create virtual environment
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```



### Server Deployment
1. Copy files to server
2. Run deployment script
```bash
sudo bash deploy.sh
```



2. Sprawdź, czy port 5000 jest dostępny:
```bash
curl http://localhost:5000
```
