#!/usr/bin/env python
# -*- coding: utf-8 -*-

from mysolr import Solr
import codecs

def convert_to_utf(val):
    tmpstr = unicode(str(val),'utf-8').encode('ascii','xmlcharrefreplace')
    return tmpstr

print 'Content-type:text/html\r\n\r\n'
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

print convert_to_utf("""<form name="input" <form method="post" action="solr.cgi">
    <input type="text" name="query">
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

print '</div> '

print '</body>'
print '</html>'



    
