
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
Une fois le projet ouvert dans l'IDE (RStudio / Pycharm) exécutez la commande suivante : 

```
install.packages(readLines("requirements.txt"))
```
Exécutez ensuite le fichier app.R

Le fichier **requirements.txt** contient tous les packages nécessaires au bon fonctionnement du dashboard.

Les dépendances : 
- leaflet (carte)
- sf (encodage)
- tidyverse
- ggplot2 (graphiques)
- dplyr
- shiny (dashboard)

Pour démarrer le dashboard il suffit d'executer le fichier __app.R__ à la racine.

## Rapport d'analyse

Dans cette partie, il s'agira d'analyser succintement chaque graphiques généré.

### Répartition des types d'espace vert

Ce graphique en "camembert" montre les types d'espaces verts les plus présents dans Paris.

Type d'espace vert le plus présent : décorations sur la voie publique

Le nombre d'ouvertures des espaces verts devient conséquent à partir des années 2000.

Un pic est observé en 2016 avec 107 ouvertures.

### Nombre d'espaces verts et surfaces cumulées par arrondissement

Le premier graphique en nuage de points montre le nombre d'espaces verts par arrondissement parisien.

L'arrondissement avec le plus d'espaces verts (tout type cumulé) est le 13ème (227 ev.), suivi du 19ème (217 ev.)

Il est intéressant de comparer la quantité d'espaces verts avec les surfaces cumulées.

Le second graphique en barre montre les surfaces totales réelles cumulées de tous les espaces verts par arrondissement.

On observe donc que le 12ème possède les espaces verts les plus conséquents suivis du 20 ème arrondissement

### Histogramme du nombre d'espaces verts par intervalle de surface.

Cet histogramme montre le nombre d'espaces verts par tranche de surfaces (Respectivement : 0-100, 100-1000, 1000-10 000, 10 000-100 000,+100 000 m²)

Les espaces verts ont (en majorité) une surface comprise entre 100 et 1000 m²


### Répartition par type de voie

Ce graphique en barres (avec les axes x et y inverser) montre où se situent en majorité les espaces verts.

Ce graphique indique que les rues (1252) sont les types de voie où se situent le plus les espaces verts suivi des places (214).

Les valeurs (NA) sont les espaces verts qui ont un type de voie non renseigné (arbitraire)

### Nombre d'espaces verts ouverts et / ou rénovés par année

Ce graphique en barres montre les ouvertures et rénovations par année jusqu'en 2023.

Il s'agit d'un graphique dynamique et il est possible de modifier l'affichage pour voir uniquement les Ouvertures, Rénovations ou les deux.

Il est également possible de changer la date minimale d'affichage des données.


### Géolocalisation des espaces verts parisiens

Cette carte est générée à l'aide du package "leaflet" et "sf".

La création de la carte nécessite le fichier assets/espaces_verts.geojson qui permet de dessiner les polygones sur la carte.

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