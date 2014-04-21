Skrypt repos_info_downloader.pl nale�y uruchamia� podaj�c 4 parametry:

- login na GitHubie
- has�o na GitHubie (b�dzie ca�y czas widoczne, ale co tam)
- id repozytorium, na kt�rym poprzednie pobieranie si� zako�czy�o (repo o tym id nie zostanie pobrane)
- id repozytorium na kt�rym chcemy zako�czy� pobieranie (prawdopodobnie zako�czy si� o kilka(set) repozytori�w dalej,
	wi�c aby kontynuowa� pobieranie, trzeba sprawdzi� ostatnie id wpisane do pliku repos_info.txt)

Skrypt umo�liwia jednoczesn� prac� na kilku instancjach - wyniki nale�y ze sob� scali�.

Instalka perla: http://www.activestate.com/activeperl/downloads
Wymagane jest zainstalowanie programu curl w wersji z ssl obs�uguj�cej po��czenia z https - do repo wrzucona jest wersja 64bit.
Nale�y skopiowa� j� do miejsca b�d�cego w PATH (np. C:\Windows\system32) wraz z do��czonym certyfikatem (kt�ry mo�na zainstalowa�, nie wiem czy jest to wymagane).


Konto na githubie, poprzez kt�re mo�na crawlowa� i nie pokazywa� has�a do w�asnego konta:
login: isifake
has�o: isifake0


Jak zainstalowa� Pygmenta i jakiego polecenia u�y� do znalezienia j�zyka:
1. Trzeba mie� zainstalowanego pythona (bo pygment to tak naprawd� pakiet Pythona).
2. P�niej trzeba zainstalowa� program pip. http://www.pip-installer.org/en/latest/installing.html#install-pip
3. Doda� do PATHa �cie�k� do scrypt�w pythona, u mnie "C:\Python27\Scripts"
4. Wywo�a� polecenie pip install Pygments
Teraz ju� mo�na u�ywa� polece� pygmentowych. Polecenie, kt�re zwraca j�zyk danego pliku, to: "pygmentize -N plik_z_kodem.xxx"
Zamieszczony opis instalacji dzia�a na Windowsie, ale podejrzewam, �e dla Linuksa te� powinien dzia�a�.