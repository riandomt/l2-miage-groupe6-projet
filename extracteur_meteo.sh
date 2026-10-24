#!/bin/bash
# Projet météo - Groupe 6
# Membres : BELBOUALIA, AMARA, KHERIBI, MITTOU, PATIR, TABLAT
# Variante 2 : export JSON

VILLE="Paris"
DATE=$(date '+%Y-%m-%d')
HEURE=$(date '+%H:%M:%S')

curl -s "https://wttr.in/$VILLE?T" -o meteo_brut.txt

TEMP=$(grep -o '+[0-9]*' meteo_brut.txt | head -1 | tr -d '+')
VENT=$(grep -o '[0-9][0-9]* km/h' meteo_brut.txt | head -1)
HUMIDITE=$(grep -o '[0-9]*%' meteo_brut.txt | head -1)

echo "{"                                      > meteo.json
echo "  \"date\": \"$DATE\","                >> meteo.json
echo "  \"heure\": \"$HEURE\","             >> meteo.json
echo "  \"ville\": \"$VILLE\","             >> meteo.json
echo "  \"temperature\": \"${TEMP}°C\","    >> meteo.json
echo "  \"vent\": \"$VENT\","               >> meteo.json
echo "  \"humidite\": \"$HUMIDITE\""        >> meteo.json
echo "}"                                     >> meteo.json

echo "Fichier meteo.json généré avec succès"
head -20 meteo.json