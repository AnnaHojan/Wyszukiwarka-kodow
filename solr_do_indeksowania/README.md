Uwaga! wszytki pliki ktore umieściła Emilia sa juz zaindeksowane

Uruchomienie solra:
1) wchodzimy cd solr/example
2) uruchamiamy java -jar start.jar
i solr już działa
Uwaga: indeksować można tylko przy włączonym solrze

Indeksowanie plików:
do tego służy sktypt post.sh

uruchomienie: sh post.sh nazwapliku.xml

Jeśli się powiedzie to da mniej wiecej cos takiego na wyjscie:

<?xml version="1.0" encoding="UTF-8"?>
<response>
<lst name="responseHeader"><int name="status">0</int><int name="QTime">360</int></lst>
</response>

<?xml version="1.0" encoding="UTF-8"?>
<response>
<lst name="responseHeader"><int name="status">0</int><int name="QTime">197</int></lst>
</response>

Hacki:
Trzeba na pewno zamienić & na &amp;
Można uzyc:
sed 's/&/&amp;/g' repos_info_4.xml > output.xml

I recznię pousywać znaki typu : 

nie wszytkie znaczniki <field> są zamnknięte

----------
Trzeba wymyślić sposób zeby zamienić < na &lt;

">" nie trzeba zmieniać to nie psuje niczego

----------------
dostęp do solra lokalnie : http://localhost:8983/solr
