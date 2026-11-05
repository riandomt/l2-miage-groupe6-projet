#!/bin/bash
# Projet météo - Groupe 6
# Variante 2 : option -j pour sauvegarder en JSON au lieu du fichier texte
# Usage : ./extracteur_meteo.sh [-a] [-j] [ville]

archive=0
json=0
while [ "$1" = "-a" ] || [ "$1" = "-j" ]; do
    if [ "$1" = "-a" ]; then archive=1; fi
    if [ "$1" = "-j" ]; then json=1; fi
    shift
done

VILLE_PAR_DEFAUT="Toulouse"
ville="$1"
if [ -z "$ville" ]; then
    ville="$VILLE_PAR_DEFAUT"
    echo "Aucune ville fournie, utilisation de la ville par défaut : $ville"
fi

mkdir -p donnees
curl -s "wttr.in/$ville?T" -o "donnees/meteo_temp.txt"

# Ligne 4 : température actuelle / ligne 23 : température de demain matin
temperatureActuelle=$(head -n 4 donnees/meteo_temp.txt | tail -n 1 | grep -o -- "-\?[0-9]\+" | head -n 1)
temperatureDemain=$(head -n 23 donnees/meteo_temp.txt | tail -n 1 | grep -o -- "-\?[0-9]\+" | head -n 1)

# Variante 1 : récupération des informations supplémentaires
# Vitesse du vent (ligne 5)
vent=$(head -n 5 "donnees/meteo_temp.txt" |
    tail -n 1 |
    grep -o -- "[0-9]\+ km/h" |
    head -n 1)

# Visibilité (ligne 6)
visibilite=$(head -n 6 "donnees/meteo_temp.txt" |
    tail -n 1 |
    grep -o -- "[0-9]\+ km" |
    head -n 1)

# Humidité
humidite=$(grep -o -- "[0-9]\+%" "donnees/meteo_temp.txt" |
    head -n 1)

if [ -z "$humidite" ]; then
    humidite="non disponible"
fi

# Valeurs de secours
if [ -z "$vent" ]; then
    vent="non disponible"
fi

if [ -z "$visibilite" ]; then
    visibilite="non disponible"
fi

# Vérification si les températures ont été trouvées
if [ -z "$temperatureActuelle" ] || [ -z "$temperatureDemain" ]; then
    echo "Erreur : température non trouvée."
    echo "Données conservées dans donnees/meteo_temp.txt pour le débogage."
    exit 1
fi

date_jour=$(date +%Y-%m-%d)
heure=$(date +%H:%M:%S)

if [ "$json" -eq 1 ]; then
    # Mode JSON : remplace le fichier texte, contient la dernière mesure
    echo "{"                                                         > donnees/meteo.json
    echo "  \"date\": \"$date_jour\","                               >> donnees/meteo.json
    echo "  \"heure\": \"$heure\","                                  >> donnees/meteo.json
    echo "  \"ville\": \"$ville\","                                  >> donnees/meteo.json
    echo "  \"temperature\": \"${temperatureActuelle}°C\","          >> donnees/meteo.json
    echo "  \"prevision\": \"${temperatureDemain}°C\","              >> donnees/meteo.json
    echo "  \"vent\": \"$vent\","                                    >> donnees/meteo.json
    echo "  \"humidite\": \"$humidite\","                            >> donnees/meteo.json
    echo "  \"visibilite\": \"$visibilite\""                         >> donnees/meteo.json
    echo "}"                                                         >> donnees/meteo.json
    echo "Données enregistrées dans donnees/meteo.json"
else
    # Ligne formatée issue de la variante 1 avec toutes les informations
    ligne="$date_jour - $heure - $ville : ${temperatureActuelle}°C - ${temperatureDemain}°C - Vent : $vent - Humidité : $humidite - Visibilité : $visibilite"

    echo "$ligne" >> donnees/meteo.txt
    if [ "$archive" -eq 1 ]; then
        jour=$(echo "$date_jour" | tr -d '-')
        echo "$ligne" >> "donnees/meteo_$jour.txt"
    fi
fi
