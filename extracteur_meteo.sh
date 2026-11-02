#!/bin/bash


# Version 3 : option -a pour archiver dans un fichier par jour
archive=0
if [ "$1" = "-a" ]; then
    archive=1
    shift
fi


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

# Récupération des données météo de la ville spécifiée
curl -s "wttr.in/$ville?T" -o "donnees/meteo_temp.txt"

# Extraction des températures en conservant le signe négatif éventuel
temperatureActuelle=$(
    head -n 4 "donnees/meteo_temp.txt" |
        tail -n 1 |
        grep -o -- "-\?[0-9]\+" |
        head -n 1
)

temperatureDemain=$(
    head -n 23 "donnees/meteo_temp.txt" |
        tail -n 1 |
        grep -o -- "-\?[0-9]\+" |
        head -n 1
)

# Vérification si les températures ont été trouvées
if [ -z "$temperatureActuelle" ] || [ -z "$temperatureDemain" ]; then
    echo "Erreur : température non trouvée."
    echo "Données conservées dans donnees/meteo_temp.txt pour le débogage."
    exit 1
fi

# Formatage des températures
temperatureActuelle="${temperatureActuelle}°C"
temperatureDemain="${temperatureDemain}°C"

# Ajout des données dans le fichier meteo.txt
date_jour=$(date +%Y-%m-%d)
heure=$(date +%H:%M:%S)
ligne="$date_jour - $heure - $ville : $temperatureActuelle - $temperatureDemain"
echo "$ligne" >> "donnees/meteo.txt"

# Version 3 : copie dans le fichier du jour (donnees/meteo_AAAAMMJJ.txt)
if [ "$archive" -eq 1 ]; then
    jour=$(echo "$date_jour" | tr -d '-')
    echo "$ligne" >> "donnees/meteo_$jour.txt"
fi
