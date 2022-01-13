# IOT

Podstawowy serwer, bez autoryzacji i z lokalną bazą danych


# Użycie:

skonfigurować mosquitto.conf, 
- ustawić listener na porcie 1883: listener 1883 (w sekcji listeners)

- uruchomić broker.py, należy mieć zainstalowane mosquitto na ścieżce jak w pliku, lub zmienić scieżkę
- uruchomić database.py w postaci: python database.py, to utworzy nową baze danych usuwając starą
- uruchomić register.py w postaci: python register.py [adres ip do rejestracji]
- uruchomić server.py w postaci: python server.py [adres ip waszego komputera (brokera)]
- uruchomić client.py: python client.py [adres ip waszego komputera (brokera)] [jakaś nazwa (żeby rozróżnić klientów, ta nazwa wyświetla się w oknie tkinter)]

server.py generuje lokalną baze danych
na pierwszą wiadmość od danego klienta odpisuje hello i zapisuje go jako:
- nazwę, czas, None, None

na drugią wiadmość od danego klienta odpisuje ceną obliczoną na podstawie różnicy czasu aktualizuje wpis w bazie danych:
- (old) nazwa, (old) czas, (new) czas wyjścia, (new) obliczona cena

Client wysyłając wiadomość na temacie client/request/[adres ip] zaczyna subskrybować na temacie client/response/[adres ip] 
po otrzymaniu odpowiedzi klient przestaje subskrybować dany temat


# Planowane zmiany:
- ustawienie qos
- autoryzacja

# Kacper CHANGELOG
### client.py:
- Wyczyszczenie kodu
- Dodadnie logów
- Pobieranie w inny, prostszy sposób adresu ip klienta

### server.py
- Wyczyszczenie kodu z komentarzy
- Zmiana interpolacji stringów: .fromat() -> f""
- Dodanie logów
- Ujednolicenie czasu (obecny czas (`curr_time = time.ctime()`) jest pobierany raz i ten czas jest zapisywany do bazy danych oraz przesyłane clientowi, aby nie było różnicy w czasie wyświetlenia go w logach serwera, clienta oraz w bazie danych)
- Nowy sposóbu przesyłu responsów:
-- Zmiana oddzielania inforamcji: ',' -> '@'
-- Dodanie informacji o czasie w przesyłanym responsie (aby client nie pobierał go u siebie osobno (patrz: zmiana `Ujednolicenie czasu`)
-- Zrezygnowanie z przesyłania `msg="Hello"`
-- Zrezygnowania z przesyłania w responsie `client_ip`

* Nowy schemat przsyłania responsów:
-- WEJŚCIE (1 odbicie): response = `"czas_odbicia_wejścia"`
-- WYJŚCIE (2 odbicie): response = `"czas_odbicia_wyjścia@cena@czas_przejazdu"`
-- JEŻELI KLIENT NIE JEST ZAREJSTROWANY: response = `"czas_odbicia@error_msg"` (gdzie `error_msg = "Sorry, you are not registered!"`)
  
# Pyoter CHANGELOG
* Zmiana nazw plików:
-- server.py oraz client.py służą tylko do odpalania gui
-- server_connector.py i client_connector.py służą do komunikacji pomiędzy gui, a resztą aplikacji (tego nie ruszać)
-- server_functions.py i client_functions.py zawierają wszystkie funkcje powiązane z mqtt (stare server.py i client.py)
* Wprowadzenie klas i obiektów - framework, którego używałem zmusza do takiego podejścia
* Dodanie sygnałów umożliwiających komunikację z connectorami w celu wysyłania odpowiednich informacji o wykonanych akcjach 
* W przypadku serwera może po zamknięciu okienka pojawiać się błąd, ale jest on związany ze złą kolejnością usuwania obiektów i nie ma się czym martwić (postaram się naprawić)
* Do uruchomienia gui potrzebna jest biblioteka Pyside2, najlepiej ją dodać za pomocą `pip install Pyside2`
* Uruchamianie programu przebiega w dokładnie taki sam sposób jak wcześniej (gui mają tylko client i server, ponieważ database i broker to w zasadzie pojedyncze funkcje)