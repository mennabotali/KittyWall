// KittyWall sans briques centrales
// Compatible OpenSCAD 2021.01
// Unites : millimetres

niveau_detail = 3;

nb_colonnes_briques = 6;
nb_rangees_briques = 8;
largeur_brique = 34;
hauteur_brique = 12;
profondeur_brique = 23;
espace_brique = 1.2;

chevauchement_mur = 0.2;

profondeur_socle = 60;
hauteur_socle = 10;

largeur_montant = 22;
profondeur_montant = 24;
hauteur_supplementaire_montant = 10;

largeur_dent = (largeur_brique + espace_brique) / 2;
profondeur_dent = 24;
hauteur_dent = hauteur_brique;

espace_lateral = 0;
marge_exterieure = 25;

$fn = niveau_detail == 1 ? 20 :
      niveau_detail == 2 ? 40 : 64;

// Fonctions

function dent_interieure_rangee(r) =
    (r % 2 == 0);

function nombre_briques_rangee(r) =
    dent_interieure_rangee(r) ? nb_colonnes_briques + 1 : nb_colonnes_briques + 2;

function largeur_briques(n) =
    n * largeur_brique + (n - 1) * espace_brique;

function largeur_max_mur() =
    largeur_briques(nb_colonnes_briques + 2);

function largeur_entre_montants() =
    largeur_max_mur() + 2 * espace_lateral;

function largeur_rangee(r) =
    largeur_briques(nombre_briques_rangee(r));

function largeur_dent_rangee(r) =
    largeur_dent;

function largeur_dent_fusion(r) =
    largeur_dent_rangee(r) + chevauchement_mur;

function hauteur_mur() =
    nb_rangees_briques * hauteur_brique + (nb_rangees_briques - 1) * espace_brique;

function hauteur_montant() =
    hauteur_mur() + hauteur_supplementaire_montant;

function largeur_socle() =
    largeur_entre_montants() + 2 * (largeur_montant + marge_exterieure);

// Modules

module bloc_arrondi(taille=[10,10,10], r=1) {
    if (r > 0) {
        linear_extrude(height=taille[2], center=true)
            offset(r=r)
                square([taille[0]-2*r, taille[1]-2*r], center=true);
    } else {
        cube(taille, center=true);
    }
}

module bloc_bois(taille=[10,10,10], r=1.2) {
    color([0.82, 0.66, 0.45])
        bloc_arrondi(taille, r);
}

// Socle

module socle() {
    translate([0, 0, hauteur_socle/2])
        bloc_bois([largeur_socle(), profondeur_socle, hauteur_socle], 2);

    if (niveau_detail >= 2) {
        color([0.68, 0.50, 0.32])
        translate([0, -profondeur_socle/2 + 7, hauteur_socle + 0.2])
            cube([largeur_socle() - 16, 1, 0.7], center=true);
    }

    if (niveau_detail >= 3) {
        color([0.68, 0.50, 0.32])
        translate([0, profondeur_socle/2 - 7, hauteur_socle + 0.2])
            cube([largeur_socle() - 16, 1, 0.7], center=true);
    }
}

// Structure dents

module dents_rangee(r) {
    if (dent_interieure_rangee(r)) {
        largeur_dent_r = largeur_dent_rangee(r);
        largeur_dent_f = largeur_dent_fusion(r);

        for (sens_x = [-1, 1]) {
            position_dent_x = sens_x * (
                largeur_rangee(r)/2
                + largeur_dent_r/2
                - chevauchement_mur/2
            );

            translate([position_dent_x, 0, 0])
                bloc_bois([largeur_dent_f, profondeur_dent, hauteur_dent], 0.6);
        }
    }
}

module mur_briques() {
    // Les briques sont retirees : on garde seulement les dents laterales.
    debut_z = hauteur_socle + hauteur_brique/2;

    for (r = [0 : nb_rangees_briques - 1]) {
        z = debut_z + r * (hauteur_brique + espace_brique);

        translate([0, 0, z])
            dents_rangee(r);
    }
}

// Montants lateraux

module montant_lateral(gauche=true) {
    sens_x = gauche ? -1 : 1;

    position_montant_x = sens_x * (
        largeur_entre_montants()/2 + largeur_montant/2
    );

    translate([position_montant_x, 0, hauteur_socle + hauteur_montant()/2])
        bloc_bois([largeur_montant, profondeur_montant, hauteur_montant()], 1.2);
}

// Assemblage

module jeu_kittywall() {
    socle();
    montant_lateral(true);
    montant_lateral(false);
    mur_briques();
}

jeu_kittywall();
