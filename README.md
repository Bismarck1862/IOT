# IOT

Podstawowy serwer, bez autoryzacji i z lokalną bazą danych


# Usage:

skonfigurować mosquitto.conf, 
- ustawić listener na porcie 1883: listener 1883 (w sekcji listeners)

uruchomić broker.py, należy mieć zainstalowane mosquitto na ścieżce jak w pliku, lub zmienić scieżkę

uruchomić server.py w postaci: python server.py [adres ip waszego komputera]
uruchomić client.py: python client.py [adres ip waszego komputera] [jakaś nazwa (żeby rozróżnić klientów, ta nazwa wyświetla się w oknie tkinter)]

server.py generuje lokalną baze danych
na pierwszą wiadmość od danego klienta odpisuje hello i zapisuje go jako:
- nazwę, czas, None, None

na drugią wiadmość od danego klienta odpisuje ceną obliczoną na podstawie różnicy czasu aktualizuje wpis w bazie danych:
- (old) nazwa, (old) czas, (new) czas wyjścia, (new) obliczona cena

Client wysyłając wiadomość na temacie client/request/[nazwa klienta] zaczyna subskrybować na temacie client/response/[nazwa klienta] 
po otrzymaniu odpowiedzi klient przestaje subskrybować dany temat, dzięki temu możemy symulować systuacje gdy wchodząć odbijamy kartę na kasowniku/skanerze 1
i wychodząc odbijamy na skanerze 2. 

# Do przemyślenia
Na razie zrezygnowałem z identyfikacje po adresie ip klienta, jednak:
- Można dodać te adresy i symulować że jeden adres to jeden pojazd/jednostka, więc w danym pojeździe mogłoby być wiele kasowników działających jak to opisałem powyżej a jednocześnie wpisy z różnych adresów ip/pojazdów by się ze sobą nie mieszały (nie można wejść do autobusu A i wyjść w autobusie B).
- Można wprowadzić jakieś zabezpieczenie, np wywyłanie jakiegoś kodu(hasła) w wiadmości, ale wtedy serwer musi mieć baze klientów z ich hasłami by dokonać autoryzacji.


# Planowane zmiany:
- ustawienie qos
- autoryzacja


