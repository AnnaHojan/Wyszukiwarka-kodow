Skrypt repos_info_downloader.pl nale¿y uruchamiaæ podaj¹c 4 parametry:

- login na GitHubie
- has³o na GitHubie (bêdzie ca³y czas widoczne, ale co tam)
- id repozytorium, na którym poprzednie pobieranie siê zakoñczy³o (repo o tym id nie zostanie pobrane)
- id repozytorium na którym chcemy zakoñczyæ pobieranie (prawdopodobnie zakoñczy siê o kilka(set) repozytoriów dalej,
	wiêc aby kontynuowaæ pobieranie, trzeba sprawdziæ ostatnie id wpisane do pliku repos_info.txt)

Skrypt umo¿liwia jednoczesn¹ pracê na kilku instancjach - wyniki nale¿y ze sob¹ scaliæ.

Instalka perla: http://www.activestate.com/activeperl/downloads
Wymagane jest zainstalowanie programu curl w wersji z ssl obs³uguj¹cej po³¹czenia z https - do repo wrzucona jest wersja 64bit.
Nale¿y skopiowaæ j¹ do miejsca bêd¹cego w PATH (np. C:\Windows\system32) wraz z do³¹czonym certyfikatem (który mo¿na zainstalowaæ, nie wiem czy jest to wymagane).


Konto na githubie, poprzez które mo¿na crawlowaæ i nie pokazywaæ has³a do w³asnego konta:
login: isifake
has³o: isifake0


Jak zainstalowaæ Pygmenta i jakiego polecenia u¿yæ do znalezienia jêzyka:
1. Trzeba mieæ zainstalowanego pythona (bo pygment to tak naprawdê pakiet Pythona).
2. PóŸniej trzeba zainstalowaæ program pip. http://www.pip-installer.org/en/latest/installing.html#install-pip
3. Dodaæ do PATHa œcie¿kê do scryptów pythona, u mnie "C:\Python27\Scripts"
4. Wywo³aæ polecenie pip install Pygments
Teraz ju¿ mo¿na u¿ywaæ poleceñ pygmentowych. Polecenie, które zwraca jêzyk danego pliku, to: "pygmentize -N plik_z_kodem.xxx"
Zamieszczony opis instalacji dzia³a na Windowsie, ale podejrzewam, ¿e dla Linuksa te¿ powinien dzia³aæ.