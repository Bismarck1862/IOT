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

Client wysyłając wiadomość na temacie client/request/[adres ip] zaczyna subskrybować na temacie client/response/[adres ip] 
po otrzymaniu odpowiedzi klient przestaje subskrybować dany temat


# Planowane zmiany:
- ustawienie qos
- autoryzacja


