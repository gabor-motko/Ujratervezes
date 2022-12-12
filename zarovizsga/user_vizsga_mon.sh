#!/usr/bin/bash

mkdir /home/vizsga2022_mon
cd /home/vizsga2022_mon

LOG=/home/vizsga2022_mon/vizsga_monitor.txt

name=`whoami`
date=`date +'%Y.%m.%d'`
hostname=`hostname`

echo -e "***\n*" > $LOG
echo "* Nevem : Motkó Gábor ($name)" >> $LOG
echo "* Dátum : $date" >> $LOG
echo "* Számítógép : $hostname" >> $LOG
echo -e "*\n***" >> $LOG

ip addr | grep 'inet ' | sed -r 's/^ *//' | cut --delimiter=' ' -f2 >> $LOG

getent group | cut -d: -f1 >> $LOG
getent passwd | grep -v nologin >> $LOG

# 2. kérdés 4. feladat - tűzfal inbound szabályai
# Az UFW alapértelmezetten ki van kapcsolva és nincsenek szabályok (ezt az Azure kezeli).
ufw status >> $LOG

mkdir ./szoveg

for file in `find /var -iname '*.txt'`; do
	dst=`echo $f | rev | cut -d/ -f1 | rev` # utolsó '/' utáni rész, azaz a fájlnév
	cp -fv "$file" "./szoveg/$dst"
done

mkdir ./web
echo "Záró vizsga" > ./web/main.html

rm -rf ./*
ufw disable
