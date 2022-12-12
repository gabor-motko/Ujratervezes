#!/usr/bin/bash

mkdir /home/vizsga2022
cd /home/vizsga2022

groupadd vivok
groupadd uszok
groupadd birkozok

useradd -p Passw0rd fuchs_jeno
useradd -p Passw0rd posta_sandor
useradd -p Passw0rd piller_gyorgy
useradd -p Passw0rd egerszegi_krisztina
useradd -p Passw0rd darnyi_tamas
useradd -p Passw0rd cseh_laszlo
useradd -p Passw0rd varga_janos
useradd -p Passw0rd repka_attila
useradd -p Passw0rd farkas_peter

usermod -aG vivok fuchs_jeno
usermod -aG vivok posta_sandor
usermod -aG vivok piller_gyorgy
usermod -aG uszok egerszegi_krisztina
usermod -aG uszok darnyi_tamas
usermod -aG uszok cseh_laszlo
usermod -aG birkozok varga_janos
usermod -aG birkozok repka_attila
usermod -aG birkozok farkas_peter

mkdir ./szakosztalyok
mkdir ./szakosztalyok/vivas
mkdir ./szakosztalyok/uszas
mkdir ./szakosztalyok/birkozas

chown :vivok ./szakosztalyok/vivas
chown :uszok ./szakosztalyok/uszas
chown :birkozok ./szakosztalyok/birkozas
chmod g=rwx ./szakosztalyok/vivas
chmod g=rwx ./szakosztalyok/uszas
chmod g=rx ./szakosztalyok/birkozas

find /usr/lib -size +10M

head -n 3 /etc/passwd
tail -n 2 /etc/passwd
grep var /etc/passwd
