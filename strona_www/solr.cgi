#!/usr/bin/env python
# -*- coding: utf-8 -*-
import cgi
from mysolr import Solr
import codecs

# funkcja do printowania stringów zawierajacych polskie litery bo inaczej sie pojawiaja krzaczki
def convert_to_utf(val):
    tmpstr = unicode(str(val),'utf-8').encode('ascii','xmlcharrefreplace')
    return tmpstr


#pobieramy wpisane zapytanie
form = cgi.FieldStorage()
if 'query' not in form:
    input_query = "*"
else:
    input_query = form["query"].value
if 'pole' not in form:
    wyszukaj_po = "commit_diff"
else:
    wyszukaj_po = form["pole"].value


#czesc solrowa    
solr = Solr('http://localhost:8983/solr/')
if((wyszukaj_po =="description" or wyszukaj_po =="commit_message" or wyszukaj_po =="comment" or
    wyszukaj_po =="commit_diff")  and input_query != "*"):
    query = {'q' : wyszukaj_po+':'+input_query, 'wt' : 'json','intend':'true',"hl":"true","hl.fl":wyszukaj_po,
            "hl.simple.pre":'<strong>', "hl.simple.post":'</strong>',"rows":2147483647}
else:
    query = {'q' : wyszukaj_po+':'+input_query, 'wt' : 'json','intend':'true',"rows":2147483647}

response = solr.search(**query)
documents = response.documents

liczba_wynikow = response.total_results



print "Content-type:text/html\r\n\r\n"
print '<html>'
print '<head>'
print '<meta charset="utf-8">'
print '<meta name="viewport" content="width=device-width, initial-scale=1">'
print '<link href="css/bootstrap.min.css" rel="stylesheet">'
print '<link href="css/main.css" rel="stylesheet">'
print '<script src="js/bootstrap.min.js"></script>'
print convert_to_utf('<title>Wyszukiwarka kodów</title>')
print '</head>'
print '<body>'
print '<div class="col-md-5 col-md-offset-4">'
print convert_to_utf('<a href="/index.cgi"><h1>Wyszukiwarka kodów</h1></a>')

#print input_query
#print wyszukaj_po

print convert_to_utf("""<form name="input" <form method="post" action="solr.cgi">
    <input type="text" name="query" value="""+input_query+""">
    <input class="btn btn-primary" type="submit" value="Wyszukaj">
    <h6><small>Wyszukiwanie zaawansowane. Wyszukaj po: </small></h6>
    <div class="form-inline"><input type="radio" name="pole" value="name">nazwie repozytorium
    <input type="radio" name="pole" value="description">opisie
    <input type="radio" name="pole" value="contributor">autorze
    <input type="radio" name="pole" value="language">języku</div>
    <div class="form-inline"><input type="radio" name="pole" value="commit_message">teści commita
    <input type="radio" name="pole" value="filename">nazwie pliku
    <input type="radio" name="pole" value="comment">treści komentarza</div>
    <input class="last-radio" type="radio" name="pole" value="commit_diff">fragmencie kodu
     </form> """)

if(liczba_wynikow==0 or str(liczba_wynikow)=='None'):
    print convert_to_utf("<p class='lead'>Brak wyników dla podanego zapytania</p>")

else:
    print convert_to_utf("<p class='lead'>Znaleziono " + str(liczba_wynikow) + " wyników pasujących do zapytania:</p>")    
    print convert_to_utf("<p>wyszukanie zajęło " + str(response.qtime*0.001) + " s</p>")
    #sprawdzić czy moze być więcejwynkiów niż jeden
    #print response.highlighting['Wyszukiwarka-kodow']['opis'][documents[i]["id"]]
    print '<ol>'
    for i in range(liczba_wynikow):      
        print '<li>'
        print '<div class="wynik">'
        
        if('url' in documents[i]):
            print convert_to_utf('<a  href='+ documents[i]["url"] +'>')
        
        if('name' in documents[i]):
            print convert_to_utf('' + documents[i]["name"] + '')
        if('url' in documents[i]):
            print '</a><br>'
        if('url' in documents[i]):
            print convert_to_utf('' + documents[i]["url"] + '<br>')
        if('updated_at' in documents[i]):
            print convert_to_utf('<small>' + documents[i]["updated_at"][:10] + '</small><br>')
        if('language' in documents[i]):
            documents[i]["language"] = [x.lower() for x in documents[i]["language"]]
            documents[i]["language"] = list(set(documents[i]["language"]))
            for j in range(len(documents[i]["language"])):
                print convert_to_utf('<span class="btn btn-success">' + documents[i]["language"][j] + '</span>')
        if(wyszukaj_po =="description" or wyszukaj_po =="commit_message" or wyszukaj_po =="comment" or
            wyszukaj_po =="commit_diff"):
            print convert_to_utf('</br>' +response.highlighting[str(documents[i]["id"])][wyszukaj_po][0]+ '<br>')
        else :
            if('description' in documents[i]):        
                print convert_to_utf('</br>' + documents[i]["description"] + '<br>')
        print '</br>'
        
        print '</div>'
        print '</li>'

    print '</ol>'
        
print '</div> '        


print '</body>'
print '</html>'
