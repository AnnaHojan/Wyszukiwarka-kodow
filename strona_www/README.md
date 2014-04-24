Na maszyne wirtualna jest to wrzucone w folderze /srv/http oraz /srv/http/cgi-bin
Tam jest troche stara wersja na gitie najnowsza

Zwykły pilk .html poprawinie się wyświetla, ale plik cgi printuje się po prostu na ekran a nie wykonuje
tau2013z.vm.wmi.amu.edu.pl/index.cgi

Przydatnie komendy:
logowanie: ssh -p 1977 isi@tau2013z.vm.wmi.amu.edu.pl
przerzucanie plików przez scp:
scp -P 1977 solr.cgi isi@tau2013z.vm.wmi.amu.edu.pl:/home/isi (przezucanie pliku solr.cgi do /home/isi na maszynie)

Na maszynie zainstalowany apache i mysolr (do laczenia sie w solrem w pythonie)
