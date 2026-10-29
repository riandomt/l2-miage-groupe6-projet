#!/bin/bash

# Ville utilisée si aucun argument n'est fourni
VILLE_PAR_DEFAUT="Toulouse"

# Récupération de la ville en argument
ville="$1"

# Si aucune ville n'a été fournie, on utilise la ville par défaut
if [ -z "$ville" ]; then
    ville="$VILLE_PAR_DEFAUT"
    echo "Aucune ville fournie, utilisation de la ville par défaut : $ville"
fi

# Créer le dossier "donnees" s'il n'existe pas
mkdir -p donnees

# Suppression du fichier "meteo.txt" s'il existe
rm -f "donnees/meteo.txt"

# Récupération des données météo de la ville spécifiée
curl -s "wttr.in/$ville?T" -o "donnees/meteo_temp.txt"

# Extraction des températures actuelle et prévue pour demain
temperatureActuelle=$(head -n 4 "donnees/meteo_temp.txt" | tail -n 1 | grep -o -- "[0-9]\+" | head -n 1)
temperatureDemain=$(head -n 25 "donnees/meteo_temp.txt" | tail -n 1 | grep -o -- "[0-9]\+" | head -n 1)

# Vérification si les températures ont été trouvées
if [ -z "$temperatureActuelle" ] || [ -z "$temperatureDemain" ]; then
    echo "Erreur : température non trouvée."
    exit 1
fi

# Formatage des températures
temperatureActuelle="${temperatureActuelle}°C"
temperatureDemain="${temperatureDemain}°C"

# Suppression du fichier temporaire
rm -f "donnees/meteo_temp.txt"

# Ajout des données dans le fichier meteo.txt
echo "$(date +%Y-%m-%d) - $(date +%H:%M:%S) - $ville : $temperatureActuelle - $temperatureDemain" \
    >> "donnees/meteo.txt"