# Projet de configuration d'un poste de travail
## l2-miage-groupe6-projet
#### **Configurer une tache cron:**

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

* \* \* \* \* \* : toutes les minutes 
* 0 8 \* \* \* : tous les jours à 8h00



#### **La commande à exécuter :**

cd /chemin/vers/le/projet : cron ne démarre pas dans le dossier du projet, donc on s'y place d'abord. Sinon le script ne trouverait pas le dossier donnees/.

\&\& : la suite n'est exécutée que si le cd a marché.

bash extracteur\_meteo.sh : lance le script. Sans ville en argument, il utilise la ville par défaut ; on peut aussi en préciser une, par exemple bash extracteur\_meteo.sh Paris.

`>> donnees/cron.log 2>&1` : enregistre les messages et les éventuelles erreurs du script dans le fichier donnees/cron.log. C'est pratique pour vérifier que cron a bien lancé le script.


**Arrêter la tâche cron:**

Il suffit de refaire crontab -e et de supprimer la ligne (ou d'ajouter un # au début pour la désactiver).



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
Variante 1 : Informations météo supplémentaires

Dans cette variante, nous avons ajouté trois informations supplémentaires au script :

* La vitesse du vent (km/h)
* L’humidité (%)
* La visibilité (km)

Les données sont récupérées depuis le site wttr.in à l’aide de la commande curl.

Nous utilisons les commandes head, tail et grep pour extraire les informations.

Si une information n’est pas trouvée, le script affiche « non disponible ».

Les nouvelles informations sont ajoutées dans le fichier donnees/meteo.txt avec la date, l’heure, la ville et les températures.

Exemple d’utilisation

bash extracteur_meteo.sh Toulouse

Sans argument, le script utilise Toulouse comme ville par défaut.

Exemple de résultat

2026-11-04 - 15:30:00 - Toulouse : 15°C - 17°C - Vent : 10 km/h - Humidité : 65% - Visibilité : 10 km

Cet exemple est illustratif ; les valeurs réelles dépendent des données météo récupérées.
