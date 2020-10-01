#!/bin/bash

wget -N -O delegated-apnic-latest http://ftp.apnic.net/stats/apnic/delegated-apnic-latest

for geotxt in $(ls ??.txt); do
	cat ../delegated-apnic-latest | \
	grep -i "^apnic|${geotxt%.*}|ipv4|" | \
	awk -F'|' '{printf("%s/%d\n", $4, 32-log($5)/log(2))}' | \
	./cidrmerge > ${geotxt}
done

git add *.txt
if git commit -m "update iplist" -a; then
	git push origin master
fi

true
