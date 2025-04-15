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


Stworzę dla Ciebie bota, który będzie mógł łączyć się z komputerem przez Remote Desktop Protocol (RDP) i wykonywać czynności na podstawie poleceń tekstowych, zamieniając je na akcje myszki, klawiatury oraz komendy powłoki w różnych systemach operacyjnych.

Stworzyłem bota, który może łączyć się przez Remote Desktop z komputerem i wykonywać zadania na podstawie poleceń tekstowych. Bot ten potrafi:

1. Łączyć się z komputerem przez RDP (Remote Desktop Protocol)
2. Automatycznie wykonywać akcje myszy (klikanie, przewijanie)
3. Symulować naciskanie klawiszy
4. Wyszukiwać elementy na ekranie przez rozpoznawanie obrazów
5. Odczytywać tekst z ekranu za pomocą OCR
6. Pobierać wiadomości email i wyciągać z nich kody
7. Wykonywać komendy powłoki w różnych systemach

### Przykład użycia bota:

```python
# Instalacja wymaganych bibliotek
# pip install pyautogui paramiko pytesseract pillow opencv-python

# Stworzenie instancji bota
bot = AutomationBot()

# Połączenie przez RDP
bot.connect_rdp(host="komputer.example.com", username="user", password="haslo")

# Przykład wykonania zadania z Twojego przykładu
bot.execute_task("otworz aplikacje o nazwie firefox i zaloguj sie do portalu linkedin")
bot.execute_task("pobierz z programu pocztowego ze skrzynki test@email.com ostatnia wiadomosci aby wpisac kod z wiadomosci do uwierzytelnienia")
```

Bot można także uruchomić z linii poleceń:

```bash
python automation_bot.py --task "otworz aplikacje o nazwie firefox i zaloguj sie do portalu linkedin"
```

Lub wykonać wiele zadań z pliku skryptowego:

```bash
python automation_bot.py --script zadania.txt
```

Gdzie plik `zadania.txt` zawiera listę poleceń, po jednym w każdej linii.

Bot wymaga kilku bibliotek Pythona, które należy zainstalować przed użyciem, a także programu Tesseract OCR do odczytywania tekstu z ekranu.
