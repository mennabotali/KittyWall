# KittyWall

Projet réalisé dans le cadre du cours **Services et technologies multimédia** — Université de Genève, printemps 2026.

**KittyWall** est un jeu de société physique combinant **impression 3D**, **modélisation paramétrique OpenSCAD**, **conception vectorielle 2D** et **découpe/gravure laser**. Le principe reprend celui du jeu du mur de briques : un personnage est placé au sommet d’un mur, puis les joueurs retirent ou poussent les briques une par une à l’aide de petits marteaux. Le but est de ne pas faire tomber le personnage.

Dans cette version, le personnage principal est un **chat**, d’où le nom **KittyWall**.

---

## Objectifs du projet

Ce projet a pour objectif de produire un objet de jeu complet en combinant plusieurs techniques de fabrication numérique :

- modélisation 3D paramétrique avec **OpenSCAD** ;
- impression 3D du mur, des briques et du chat ;
- conception 2D vectorielle avec **Inkscape** ;
- découpe et gravure laser des marteaux ;
- intégration possible de certains modèles, notamment le chat, dans un environnement Unity.

L’ensemble du projet a été pensé pour respecter les contraintes du cours : créer des objets personnalisés, paramétriques, imprimables ou découpables, tout en documentant le processus de conception.

---

## Principe du jeu

Le jeu se compose de :

- un mur composé de briques amovibles ;
- deux montants latéraux et un socle permettant de stabiliser le mur ;
- un chat placé au sommet du mur ;
- des marteaux découpés et gravés au laser.

Les joueurs utilisent les marteaux pour pousser les briques hors du mur. Chaque joueur joue à tour de rôle. Le joueur qui fait tomber le chat perd la partie.

---

## Contenu du dépôt

```text
KittyWall/
├── README.md
├── KittyWall_complet.scad
├── Mur_KittyWall.scad
├── Brique_seule_KittyWall.scad
├── chat_ramine.scad
├── Marteaux_KittyWall.svg
```

### Description des fichiers

| Fichier | Description |
|---|---|
| `KittyWall_complet.scad` | Modèle OpenSCAD complet du jeu KittyWall avec mur, briques, socle et montants. |
| `Mur_KittyWall.scad` | Modèle du mur sans les briques centrales, utile pour imprimer la structure séparément. |
| `Brique_seule_KittyWall.scad` | Modèle paramétrique d’une brique individuelle. |
| `chat_ramine.scad` | Modèle OpenSCAD du chat placé sur le mur. |
| `Marteaux_KittyWall.svg` | Fichier vectoriel Inkscape utilisé pour la découpe et la gravure laser des marteaux. |

---

## Technologies utilisées

- **OpenSCAD** : modélisation 3D paramétrique ;
- **Inkscape** : dessin vectoriel des marteaux ;
- **Imprimante 3D** : fabrication du mur, des briques et du chat ;
- **Découpeuse laser Glowforge Plus / Helios** : découpe et gravure des marteaux ;
- **Blender** : conversion éventuelle des modèles 3D vers des formats compatibles Unity ;
- **Unity** : intégration possible du chat dans l’environnement de jeu sérieux.

---

## Modélisation 3D

### Mur et briques

Le mur KittyWall est conçu de manière paramétrique. Les principaux paramètres contrôlent :

- le nombre de colonnes et de rangées ;
- la largeur, la hauteur et la profondeur des briques ;
- l’espace entre les briques ;
- les dimensions du socle ;
- les dimensions des montants latéraux ;
- la profondeur des dents latérales ;
- le niveau de détail du modèle.

Le système de rangées alterne entre des rangées décalées afin de reproduire visuellement une structure de mur en briques. Les dents latérales permettent de maintenir les briques tout en laissant la possibilité de les pousser avec les marteaux.

### Niveaux de détail du mur

Le fichier `KittyWall_complet.scad` utilise la variable :

```scad
niveau_detail = 3;
```

Les niveaux disponibles sont :

| Niveau | Description |
|---|---|
| `1` | Briques simples. |
| `2` | Briques avec coins légèrement arrondis. |
| `3` | Briques arrondies avec le texte `KittyWall`. |

Pour modifier le rendu, changer simplement la valeur de `niveau_detail` dans le fichier `.scad`.

---

## Modèle du chat

Le chat est modélisé dans le fichier `chat_ramine.scad`. Il est également paramétrique.

Les paramètres principaux sont :

```scad
hauteur_chat = 60;
largeur_corps = 30;
taille_oreilles = 12;
longueur_queue = 30;
niveau_detail = 3;
```

Les niveaux de détail sont :

| Niveau | Description |
|---|---|
| `1` | Formes géométriques simples. |
| `2` | Ajout du visage, des oreilles, de la queue et des pattes. |
| `3` | Ajout de détails supplémentaires : oreilles creusées, moustaches, museau et visage plus travaillé. |

Le chat est conçu comme un objet imprimable séparément, placé au sommet du mur pendant la partie.

---

## Marteaux 2D

Les marteaux sont dessinés dans `Marteaux_KittyWall.svg` avec Inkscape. Ils sont destinés à être découpés dans une plaque de peuplier de **3 mm** d’épaisseur.

Le fichier SVG combine deux opérations :

- **découpe** : contours rouges fins pour détourer la silhouette du marteau ;
- **gravure** : texte noir `KittyWall destroyer` sur le manche.

Les marteaux ont été pensés en deux couches collées entre elles afin d’obtenir plus de relief et une meilleure prise en main.

---

## Prévisualiser les modèles OpenSCAD

1. Ouvrir OpenSCAD.
2. Charger le fichier souhaité, par exemple :

```text
KittyWall_complet.scad
```

3. Appuyer sur **F5** pour prévisualiser le modèle.
4. Appuyer sur **F6** pour effectuer le rendu complet.
5. Exporter le modèle en `.stl` pour l’impression 3D.

---

## Export pour impression 3D

Pour préparer l’impression :

1. Ouvrir le fichier `.scad` dans OpenSCAD.
2. Vérifier les dimensions et le niveau de détail.
3. Faire un rendu complet avec **F6**.
4. Exporter en `.stl`.
5. Importer le `.stl` dans un slicer.
6. Régler l’orientation, le remplissage, les supports si nécessaires, puis lancer l’impression.

Recommandation : imprimer séparément le mur, les briques et le chat pour faciliter l’assemblage et améliorer la qualité du résultat final.

---

## Découpe et gravure laser

Pour fabriquer les marteaux :

1. Ouvrir `Marteaux_KittyWall.svg` dans Inkscape.
2. Vérifier que les lignes de découpe sont bien définies comme contours fins.
3. Vérifier que le texte à graver est bien en remplissage noir.
4. Importer le fichier dans le logiciel de la découpeuse laser.
5. Choisir les paramètres adaptés à une plaque de peuplier de 3 mm.
6. Lancer d’abord la gravure, puis la découpe.
7. Coller les deux couches du marteau si nécessaire.

---

## Assemblage du jeu

Après impression et découpe :

1. Placer le mur sur une surface stable.
2. Insérer les briques dans la structure.
3. Vérifier que les briques peuvent être poussées sans être trop bloquées.
4. Placer le chat au sommet du mur.
5. Utiliser les marteaux pour jouer.

Si les briques sont trop serrées, il faut augmenter légèrement l’espace entre les briques dans les fichiers OpenSCAD. Si elles tombent trop facilement, il faut réduire cet espace ou adapter les dimensions des briques.

---

## Personnalisation

Le projet peut être facilement personnalisé grâce aux paramètres OpenSCAD. Il est possible de modifier :

- la taille du mur ;
- le nombre de briques ;
- la hauteur du chat ;
- l’apparence des briques ;
- le niveau de détail ;
- le texte gravé ou imprimé ;
- la forme et la taille des marteaux.

Cette logique paramétrique permet d’adapter le jeu à différentes contraintes d’impression, de matériau ou de design.

---

## Auteurs

Projet réalisé par :

- **Ramine Yunus**
- **Menna Mahmoud**

Cours : **Services et technologies multimédia**  
Centre universitaire d’informatique — Université de Genève  
Printemps 2026

---

## Licence

Projet académique réalisé dans le cadre d’un cours universitaire.  
L’utilisation, la modification ou la réutilisation du projet doivent respecter les consignes du cours et citer les auteurs originaux.