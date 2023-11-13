
# Paris : espaces verts et assimilés

Ce projet, réalisé en R, s'appuie sur des données disponibles sur l'Open Data de la Ville de Paris. L'objectif principal est d'explorer et d'analyser divers aspects des espaces verts et des assimilés parisiens, tels que leur répartition par type, leur surface, ainsi que les ouvertures / rénovations dans le temps.

Une présentation plus détaillées du jeu de données se trouve à l'adresse suivante : 
https://opendata.paris.fr/explore/dataset/espaces_verts/information/?disjunctive.type_ev&disjunctive.categorie&disjunctive.adresse_codepostal&disjunctive.presence_cloture

## User Guide

Pour installer le projet commencez par 
cloner le dépôt : 

```
git clone https://github.com/nathansuk/DSIA-R-Dataviz
```

Le fichier **requirements.txt** contient tous les packages nécessaires au bon fonctionnement du dashboard.

Les dépendances : 
- leaflet (carte)
- sf (encodage)
- tidyverse
- ggplot2 (graphiques)
- dplyr
- shiny (dashboard)

Pour démarrer le dashboard il suffit d'executer le fichier __app.R__ à la racine.

## Developer Guide

Architecture :
![alt text](https://i.ibb.co/Wc8BJvZ/Capture-d-cran-2023-11-13-184429.png)
 
## Architecture des dossiers

| Dossier            | Responsabilité                                                                |
| ----------------- | ------------------------------------------------------------------ |
| /R/ | Contient tous les scripts R chacun responsable de l'affichage de 1 graphique  |
| /{root} |Contient le fichier principal du dashboard  |
|
| /assets |Contient les fichiers .csv et .geojson  |
| /www |Détecté automatiquement par shiny, il permet d'insérer du code css / js dans le dashboard  |

### Notes supplémentaires: 
Le fichier .geojson est un fichier à part pour géolocaliser les données des espaces verts, provient du même site que le jeu de données original.

**Le temps de chargement peut paraître long, cela est dû au chargement et mise en cache de la map représentant les données géolocalisées sur la map(leaflet)**