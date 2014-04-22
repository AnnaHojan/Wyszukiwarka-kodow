Skrypt repos_info_downloader.pl należy uruchamiać podając 4 parametry:

- login na GitHubie
- hasło na GitHubie (będzie cały czas widoczne, ale co tam)
- id repozytorium, na którym poprzednie pobieranie się zakończyło (repo o tym id nie zostanie pobrane)
- id repozytorium na którym chcemy zakończyć pobieranie (prawdopodobnie zakończy się o kilka(set) repozytoriów dalej,
	więc aby kontynuować pobieranie, trzeba sprawdzić ostatnie id wpisane do pliku repos_info.txt)

Skrypt umożliwia jednoczesną pracę na kilku instancjach - wyniki należy ze sobą scalić.




!!!!!!!!!!!!!!!!!!!!! ABY ODPALIĆ SKRYPT !!!!!!!!!!!!!!!!!!!!!



1. Instalka perla: http://www.activestate.com/activeperl/downloads

2. Po zainstalowaniu perla trzeba doinstalować 2 moduły:
- w konsoli wpisujemy cpan i czekamy na ukończenie
- w konsoli cpana wpisujemy install File::Find::Rule (z wielkich liter)
- w konsoli cpana wpisujemy install HTML::TreeBuilder::XPath

3. Wymagane jest zainstalowanie programu curl w wersji z ssl obsługującej połączenia z https - do repo wrzucona jest wersja 64bit.
Należy skopiować ją do miejsca będącego w PATH (np. C:\Windows\system32) wraz z dołączonym certyfikatem (który można zainstalować, nie wiem czy jest to wymagane).



4. Jak zainstalować Pygmenta i jakiego polecenia użyć do znalezienia języka:
	1. Trzeba mieć zainstalowanego pythona (bo pygment to tak naprawdę pakiet Pythona).
	2. Później trzeba zainstalować program pip. http://www.pip-installer.org/en/latest/installing.html#install-pip
	3. Dodać do PATHa ścieżkę do scryptów pythona, u mnie "C:\Python27\Scripts"
	4. Wywołać polecenie pip install Pygments
Teraz już można używać poleceń pygmentowych. Polecenie, które zwraca język danego pliku, to: "pygmentize -N plik_z_kodem.xxx"
Zamieszczony opis instalacji działa na Windowsie, ale podejrzewam, że dla Linuksa też powinien działać.



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


Konta na githubie, poprzez które można crawlować wielowątkowo (ale skrypt musi być w innym katalogu):

login: isifake
hasło: isifake0

login isifake1
hasło: isifake0

login isifake2, 3, 4, 5, 6
hasło: isifake0

Zachęcam do tworzenia własnych, bo dla każdego trzeba podać unikalny email.
