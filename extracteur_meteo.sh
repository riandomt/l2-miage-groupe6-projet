#!/bin/bash

# récupération de la ville en argument
ville="$1"

# vérification si la ville a été fournie en argument
if [ -z "$ville" ]; then
    echo "Utilisation : $0 <ville>"
    exit 1
fi

# créer le dossier "donnees" s'il n'existe pas
mkdir -p donnees

# suppression du fichier "meteo.txt" s'il existe
rm "donnees/meteo.txt"

# récupération des données météos de la ville spécifiée
curl -s "wttr.in/$ville?T" -o "donnees/meteo_temp.txt"

# extraction des températures actuelles et prévues pour demain
temperatureActuelle=$(sed -n "4p" "donnees/meteo_temp.txt" | grep -o -- "[0-9]\+" | head -n 1)
temperatureDemain=$(sed -n "25p" "donnees/meteo_temp.txt" | grep -o -- "[0-9]\+" | head -n 1)

# vérification si les températures ont été trouvées
if [ -z "$temperatureActuelle" ] || [ -z "$temperatureDemain" ]; then
    echo "Erreur : température non trouvée."
    exit 1
fi

# formatage des températures
temperatureActuelle="${temperatureActuelle}°C"
temperatureDemain="${temperatureDemain}°C"

# suppression du fichier temporaire
rm "donnees/meteo_temp.txt"

# ajout des données dans le fichier meteo.txt
echo "$(date +%Y-%m-%d) - $(date +%H:%M:%S) - $ville : $temperatureActuelle - $temperatureDemain" \
    >> "donnees/meteo.txt"