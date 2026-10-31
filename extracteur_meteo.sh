#!/bin/bash
# Projet météo - Groupe 6
# Membres : BELBOUALIA, AMARA, KHERIBI, MITTOU, PATIR, TABLAT
# Variante 2 : export JSON

VILLE="${1:-Paris}"
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M:%S')

mkdir -p donnees

curl -s "https://wttr.in/$VILLE?T" -o donnees/meteo_brut.txt

TEMP=$(grep -o '+[0-9]*' donnees/meteo_brut.txt | head -1 | tr -d '+')
VENT=$(grep -o '[0-9][0-9]* km/h' donnees/meteo_brut.txt | head -1)
HUMIDITE=$(grep -o '[0-9]*%' donnees/meteo_brut.txt | head -1)

echo "{"                                      > donnees/meteo.json
echo "  \"date\": \"$DATE\","                >> donnees/meteo.json
echo "  \"heure\": \"$HEURE\","             >> donnees/meteo.json
echo "  \"ville\": \"$VILLE\","             >> donnees/meteo.json
echo "  \"temperature\": \"${TEMP}°C\","    >> donnees/meteo.json
echo "  \"vent\": \"$VENT\","               >> donnees/meteo.json
echo "  \"humidite\": \"$HUMIDITE\""        >> donnees/meteo.json
echo "}"                                     >> donnees/meteo.json

echo "Fichier donnees/meteo.json généré avec succès"
head -20 donnees/meteo.json