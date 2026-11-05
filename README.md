# 🌦️ Extracteur météo — L2 MIAGE, Groupe 6

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/GNU%20Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)

## l2-miage-groupe6-projet

Script Bash qui récupère la météo d'une ville sur `wttr.in` (sortie texte uniquement), puis enregistre la température actuelle et la prévision du lendemain.

**Membres et répartition :**

| Partie | Responsable |
|-|-|
| Version 1 : script de base | MITTOU Dorian |
| Version 2 : ville par défaut + cron | KHERIBI Assia |
| Version 3 : archivage journalier (`-a`) | TABLAT Yanis |
| Variante 1 : informations supplémentaires | PATIR Yagmursu |
| Variante 2 : export JSON (`-j`) | BELBOUALIA-AMARA Chouaib |
| Variante 3 : gestion des erreurs et des logs | MITTOU Dorian |

**Utilisation :**

    chmod +x extracteur_meteo.sh
    ./extracteur_meteo.sh [-a] [-j] [ville]

Sans ville, Toulouse est utilisée par défaut. Les options se placent avant la ville.

---

## Version 1 : script de base
Il récupère les données météorologiques d'une ville passée en paramètre depuis le site wttr.in, puis les affiche selon le format suivant : [date] - [heure] - [ville] : [temperature actuel] - [temperature du lendemain]

*Exemple : 2026-11-04 - 11:00 - Paris : 7°C - 6°C*

---

## Version 2 : planifier une tâche
### **Configurer une tache cron:**

Cron est un outil de linux qui nous permet d'exécuter une commande automatiquement à un moment précis, dans notre cas pour que le script récupère la météo régulièrement, sans avoir à le lancer à la main.  

#### **Les étapes:**

1-Vérifier que cron est bien lancé:

    sudo service cron start

2-Ouvrir le fichier des taches cron:

    crontab -e

La première fois, il demande de choisir un éditeur : on a choisi nano, c'est le plus simple.

3- Ajouter cette ligne à la fin du fichier:

      0 * * * * cd /chemin/vers/le/projet && bash extracteur_meteo.sh >> donnees/cron.log 2>&1

Il faut remplacer /chemin/vers/le/projet par le chemin du projet sur votre ordinateur (on peut le trouver avec la commande pwd dans le dossier du projet). Par exemple, sous WSL: /mnt/c/Users/assia/projets/l2-miage-groupe6-projet 

4-Enregistrer et quitter nano:

CTRL+O
Entrée
CTRL+X

Le message: crontab: installing new crontab confirme que la tache est enregistrée.

5-Vérifier que la tache a bien été ajoutée:

    crontab -l

#### **Comprendre la ligne cron:**

Les 5 premiers éléments indiquent quand la commande doit être lancée:

|**Position**|**Signification**|
|-|-|
|1|minute|
|2|heure|
|3|jour du mois |
|4|mois|
|5|jour de la semaine|

Le symbole \* veut dire «n'importe quelle valeur». Donc 0 \* \* \* \* veut dire: à la minute 0 de chaque heure, c'est-à-dire toutes les heures.

**Exemples:**

- \* \* \* \* \* : toutes les minutes 
- 0 8 \* \* \* : tous les jours à 8h00

#### **La commande à exécuter :**

cd /chemin/vers/le/projet : cron ne démarre pas dans le dossier du projet, donc on s'y place d'abord. Sinon le script ne trouverait pas le dossier donnees/.

\&\& : la suite n'est exécutée que si le cd a marché.

bash extracteur\_meteo.sh : lance le script. Sans ville en argument, il utilise la ville par défaut ; on peut aussi en préciser une, par exemple bash extracteur\_meteo.sh Paris.

`>> donnees/cron.log 2>&1` : enregistre les messages et les éventuelles erreurs du script dans le fichier donnees/cron.log. C'est pratique pour vérifier que cron a bien lancé le script.

**Arrêter la tâche cron:**

Il suffit de refaire crontab -e et de supprimer la ligne (ou d'ajouter un # au début pour la désactiver).

---

## Version 3 : Gestion d'historique

L'option `-a` archive chaque relevé dans un fichier différent par jour :
`donnees/meteo_AAAAMMJJ.txt` (exemple : `donnees/meteo_20261102.txt`).
Chaque exécution avec `-a` ajoute une ligne au fichier de la journée.
L'option doit être placée avant la ville.

Exemples :

    ./extracteur_meteo.sh -a Toulouse   # meteo.txt + fichier du jour
    ./extracteur_meteo.sh -a            # ville par défaut + fichier du jour
    ./extracteur_meteo.sh Toulouse      # meteo.txt uniquement

Avec cron (toutes les heures, avec archivage) :

    0 * * * * cd /chemin/vers/le/projet && bash extracteur_meteo.sh -a >> donnees/cron.log 2>&1

---

## Variante 1 : Informations météo supplémentaires

Dans cette variante, nous avons ajouté trois informations supplémentaires au script :

- La vitesse du vent (km/h)
- L’humidité (%)
- La visibilité (km)

Les données sont récupérées depuis le site wttr.in à l’aide de la commande curl.
Nous utilisons les commandes head, tail et grep pour extraire les informations.

Si une information n’est pas trouvée, le script affiche « non disponible ».
Les nouvelles informations sont ajoutées dans le fichier donnees/meteo.txt avec la date, l’heure, la ville et les températures.

Exemple d’utilisation :

    bash extracteur_meteo.sh Toulouse

Sans argument, le script utilise Toulouse comme ville par défaut.

Exemple de résultat :

    2026-11-04 - 15:30:00 - Toulouse : 15°C - 17°C - Vent : 10 km/h - Humidité : 65% - Visibilité : 10 km

Cet exemple est illustratif ; les valeurs réelles dépendent des données météo récupérées.

---

## Variante 2 : Sauvegarde au format JSON

L'option `-j` enregistre le relevé dans `donnees/meteo.json` **au lieu** du fichier texte `meteo.txt`.
Le fichier JSON est réécrit à chaque exécution : il contient toujours la dernière mesure.
Les options se placent avant la ville.

Exemples :

    ./extracteur_meteo.sh -j Toulouse   # donnees/meteo.json uniquement
    ./extracteur_meteo.sh -j            # ville par défaut (Toulouse)
    ./extracteur_meteo.sh Toulouse      # comportement normal : meteo.txt

Exemple de fichier généré :

    {
      "date": "2026-11-03",
      "heure": "17:12",
      "ville": "Toulouse",
      "temperature": "11°C",
      "prevision": "6°C",
      "vent": "10 km/h",
      "humidite": "non disponible",
      "visibilite": "10 km"
    }

Origine des données dans la sortie texte de wttr.in :

| Champ | Ligne | Contenu |
|-|-|-|
| temperature | 4 | température actuelle |
| vent | 5 | vitesse du vent actuelle |
| visibilite | 6 | visibilité actuelle |
| prevision | 23 | température de demain matin |

L'humidité n'apparaît pas dans la sortie texte de wttr.in. Le sujet impose de travailler uniquement sur ce format, donc le champ vaut `non disponible`.

En mode `-j`, l'option `-a` n'est pas prise en compte : l'archivage journalier concerne uniquement le fichier texte.

---

## Variante 3 : Gestion des erreurs et des logs

Chaque exécution est tracée avec un horodatage dans le dossier `donnees/` :

| Fichier | Contenu |
|-|-|
| `donnees/meteo.log` | Journal global centralisant toutes les exécutions (succès, informations et erreurs) |

Format d'une ligne :

    2026-11-04 10:31:43 - ERREUR : Impossible de contacter wttr.in pour la ville Toulouse.

Erreurs détectées :
- `curl -sf` : le code de retour de curl est testé. L'option `-f` fait aussi échouer curl si le serveur répond par une erreur HTTP.
- fichier téléchargé vide (`test -s`) ;
- température actuelle ou prévision introuvable (ville inconnue de wttr.in).

En cas d'erreur, le script s'arrête avec le code de sortie `1`. Le message est aussi affiché sur la sortie d'erreur, ce qui permet de le retrouver dans `donnees/cron.log` lorsque le script est lancé par cron.

Pour consulter les succès :
    cat donnees/meteo.log
Pour consulter les erreurs :

    cat donnees/meteo_error.log