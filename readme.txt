Skrypt repos_info_downloader.pl nale�y uruchamia� podaj�c 4 parametry:

- login na GitHubie
- has�o na GitHubie (b�dzie ca�y czas widoczne, ale co tam)
- id repozytorium, na kt�rym poprzednie pobieranie si� zako�czy�o (repo o tym id nie zostanie pobrane)
- id repozytorium na kt�rym chcemy zako�czy� pobieranie (prawdopodobnie zako�czy si� o kilka(set) repozytori�w dalej,
	wi�c aby kontynuowa� pobieranie, trzeba sprawdzi� ostatnie id wpisane do pliku repos_info.txt)

Skrypt umo�liwia jednoczesn� prac� na kilku instancjach - wyniki nale�y ze sob� scali�.


Wymagane jest zainstalowanie programu curl w wersji z ssl obs�uguj�cej po��czenia z https - do repo wrzucona jest wersja 64bit.
Nale�y skopiowa� j� do miejsca b�d�cego w PATH (np. C:\Windows\system32) wraz z do��czonym certyfikatem (kt�ry mo�na zainstalowa�, nie wiem czy jest to wymagane).