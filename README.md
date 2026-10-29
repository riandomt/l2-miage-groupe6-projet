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
