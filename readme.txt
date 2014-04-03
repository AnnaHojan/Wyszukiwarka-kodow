Skrypt repos_info_downloader.pl nale¿y uruchamiaæ podaj¹c 4 parametry:

- login na GitHubie
- has³o na GitHubie (bêdzie ca³y czas widoczne, ale co tam)
- id repozytorium, na którym poprzednie pobieranie siê zakoñczy³o (repo o tym id nie zostanie pobrane)
- id repozytorium na którym chcemy zakoñczyæ pobieranie (prawdopodobnie zakoñczy siê o kilka(set) repozytoriów dalej,
	wiêc aby kontynuowaæ pobieranie, trzeba sprawdziæ ostatnie id wpisane do pliku repos_info.txt)

Skrypt umo¿liwia jednoczesn¹ pracê na kilku instancjach - wyniki nale¿y ze sob¹ scaliæ.


Wymagane jest zainstalowanie programu curl w wersji z ssl obs³uguj¹cej po³¹czenia z https - do repo wrzucona jest wersja 64bit.
Nale¿y skopiowaæ j¹ do miejsca bêd¹cego w PATH (np. C:\Windows\system32) wraz z do³¹czonym certyfikatem (który mo¿na zainstalowaæ, nie wiem czy jest to wymagane).