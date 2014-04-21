#!/bin/sh
for i in $(seq 1 10)
do
    adres_url=`sed -n 1p to_download.txt`
	echo $adres_url
	
	wget --no-check-certificate $adres_url -O jsony_git/out$i.json
done

for plik in jsony_git/*
do
    echo $plik
	clone_url=$(cat $plik | grep 'clone_url' | cut -d'"' -f4)
	#git clone clone_url
done