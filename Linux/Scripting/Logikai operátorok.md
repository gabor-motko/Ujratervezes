# Logikai operátorok parancssoros használata

## Igaz/hamis
https://www.gnu.org/software/bash/manual/bash.html#Exit-Status

A parancsoknak többféle kimenetük lehet. Ezek egyike a kilépési kód (exit status, exit code), egy egybájtos érték (0..255) ami információt ad a folyamat eredményéről:

| Kód | Jelentés|
|---|---|
|0|A folyamat sikeresen véget ért.
|1 - 125|Valamilyen hiba történt, a hibakód jelentése programonként eltérő.
|126|A parancs nem végrehajtható.
|127|A parancs nem található.
|128&nbsp;+&nbsp;N|A folyamat végrehajtást befejező jelet (terminating signal, pl. `SIGKILL`) kapott, ahol N a jel száma.

Logikai igaz-hamis értékre lefordítva nulla lesz igaz érték, bármilyen más szám hamis. Ez alapján egy parancsot lehet használni feltételként és logikai operátorok operandusaként. Scripten belül ezt a `$?` [speciális paraméterrel](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters) lehet lekérdezni.

## Kiértékelő parancsok
https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions

A Bash shell három beépített logikai kiértékelő kifejezést tartalmaz, a `[[ ... ]]` összetett parancsot, és a `[ ... ]` és `test` parancsokat. Ezek a kifejezést kiértékelve egyetlen igaz/hamis értéket adnak vissza.

## Logikai operátorok

A Bash négy logikai operátort definiál. Ezek precedencia sorrendben:

| Operátor | Jelentés |
|---|---|
|( A )|A benne foglalt kifejezést kiértékeli és egyetlen értékként adja vissza.|
|! A|Kiértékeli `A`-t és visszaadja a negáltját.|
|A && B|Logikai ÉS. Ha `A` értéke hamis, azt adja vissza. Ha `A` igaz, kiértékeli `B`-t és visszatér `B` értékével.|
|A \|\| B|Logikai VAGY. Ha `A` értéke igaz, azt adja vissza. Ha `A` hamis, kiértékeli `B`-t és visszatér `B` értékével.|

Egyenlő precedencia esetében a műveletek balról jobbra lesznek kiértékelve: `A && B && C` == `( A && B ) && C`

Azért írtam le ilyen részletességgel a && és \|\| működését, mert **a jobb oldali parancs végrehajtása függ a bal oldali parancs eredményétől**. `A && B` esetében a `B` parancs kizárólag akkor lesz végrehajtva, ha `A` eredménye igaz. Ez akkor lehet fontos, ha például egy `if` kifejezés feltételében két vagy több parancs van, aminek mellékhatásai (pl. fájlrendszer módosítása) lehetnek.

Ez alapján kétágú döntéseket (if-then-else) lehet írni a következő módon.

Példa:
```bash
# Ha a $UID értéke 0, kiírja az üzenetet.
if [[ $UID -eq 0 ]]; then
	echo "Root felhasználó"
fi

# Ha a $UID értéke nem 0, kiírja az üzenetet.
if [[ $UID -ne 0]]; then
	echo "Nem root felhasználó"
fi
```

Ezt a két parancsot a következőképpen lehet rövidíteni:

```bash
# Ha a bal oldali feltétel igaz, kiírja az üzenetet, különben nem csinál semmit.
[[ $UID -eq 0]] && echo "Root felhasználó"

# Ha a bal oldali feltétel hamis, kiírja az üzenetet, különben nem csinál semmit.
[[ $UID -eq 0]] || echo "Nem root felhasználó"
```

Egy másik példa. Itt azt akarom tesztelni, hogy a megadott felhasználó létezik-e a `getent` paranccsal, és ha igen, kiírok egy üzenetet; ha hamis, kilépek. A \`backtick\` karakterek a parancs eredményét továbbadják a kiértékelő kifejezésnek.

```bash
username="test_user"
if [[ `getent passwd $username` ]]; then
	echo "$username létezik"
else
	exit
fi
```

Ugyanez röviden:

```bash
username="test_user"
getent passwd $username && echo "$username létezik." || exit
```

Itt nem szükséges `[[ ... ]]` kiértékelő kifejezést használni, mert a `getent` egy önmagában használható értéket ad vissza.
Először a magasabb precedenciájú művelet (itt az ÉS) lesz kiértékelve. Ennek az eredményét kapja meg az alacsonyabb precedenciájú VAGY művelet.

Ezt nem csak scripten belül, hanem parancssoron is lehet használni, például rendszerfrissítéskor:

```bash
$ sudo apt update && sudo apt upgrade
```

Ez először frissíti a csomagadatbázist, és csak akkor kezdi el a rendszert frissíteni, ha sikeres volt. Ha nem (pl. az APT repó nem elérhető), nem kezdi el frissíteni a rendszert az elavult csomagadatbázis alapján.