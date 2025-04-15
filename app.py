from bot import AutomationBot

# Stworzenie instancji bota
bot = AutomationBot()

# Połączenie przez RDP
bot.connect_rdp(host="komputer.example.com", username="user", password="haslo")

# Przykład wykonania zadania z Twojego przykładu
bot.execute_task("otworz aplikacje o nazwie firefox i zaloguj sie do portalu linkedin")
bot.execute_task("pobierz z programu pocztowego ze skrzynki test@email.com ostatnia wiadomosci aby wpisac kod z wiadomosci do uwierzytelnienia")