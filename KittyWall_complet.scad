// KittyWall
// Compatible OpenSCAD 2021.01
// Unites : millimetres

// Niveaux de details :
// 1 = briques simples
// 2 = briques avec coins legerement arrondis
// 3 = briques arrondies + texte "KittyWall"
niveau_detail = 3;

nb_colonnes_briques = 6;
nb_rangees_briques = 8;
largeur_brique = 35;
hauteur_brique = 12;
profondeur_brique = 23;
espace_brique = 0.2;

chevauchement_mur = 0.2;

profondeur_socle = 60;
hauteur_socle = 10;

largeur_montant = 22;
profondeur_montant = 24;
hauteur_supplementaire_montant = 10;

// La petite dent correspond a une demi-trame de brique
// Ainsi, une rangee avec dents + 7 briques a exactement la meme largeur
// qu'une rangee sans dents + 8 briques, mais avec les joints decales
largeur_dent = (largeur_brique + espace_brique) / 2;
profondeur_dent = 24;
hauteur_dent = hauteur_brique;

// Marge laterale integree au bois
espace_lateral = 0;
marge_exterieure = 25;

// Qualite de rendu
$fn = niveau_detail == 1 ? 20 :
      niveau_detail == 2 ? 40 : 64;

// Fonctions

// La dent du mur va vers l'interieur une rangee sur deux
function dent_interieure_rangee(r) =
    (r % 2 == 0);

// Nombre de briques entieres par rangee.
// Les rangees alternent entre nb_colonnes_briques + 1
// et nb_colonnes_briques + 2 briques entieres :
// cela garde des briques identiques et cree un decalage d'une demi-brique
function nombre_briques_rangee(r) =
    dent_interieure_rangee(r) ? nb_colonnes_briques + 1 : nb_colonnes_briques + 2;

// Largeur d'une rangee composee uniquement de briques entieres
function largeur_briques(n) =
    n * largeur_brique + (n - 1) * espace_brique;

// Largeur maximale du mur.
// Les petites dents font partie integrante de la rangee avec dents
// largeur_briques(nb_colonnes_briques + 1) + 2 * largeur_dent
// est egal a largeur_briques(nb_colonnes_briques + 2)
function largeur_max_mur() =
    largeur_briques(nb_colonnes_briques + 2);

// Largeur entre les faces internes des deux montants
function largeur_entre_montants() =
    largeur_max_mur() + 2 * espace_lateral;

// Largeur occupee par les briques de la rangee
function largeur_rangee(r) =
    largeur_briques(nombre_briques_rangee(r));

// Largeur fixe de la petite dent conservee
// Les grandes dents des rangees courtes ne sont plus generees
function largeur_dent_rangee(r) =
    largeur_dent;

// Largeur de la dent avec chevauchement interne
function largeur_dent_fusion(r) =
    largeur_dent_rangee(r) + chevauchement_mur;

// Hauteur totale du mur de briques
function hauteur_mur() =
    nb_rangees_briques * hauteur_brique + (nb_rangees_briques - 1) * espace_brique;

// Hauteur totale des montants
function hauteur_montant() =
    hauteur_mur() + hauteur_supplementaire_montant;

// Largeur du socle
function largeur_socle() =
    largeur_entre_montants() + 2 * (largeur_montant + marge_exterieure);

// Arrondi des briques
function arrondi_brique() =
    niveau_detail >= 2 ? 1.2 : 0;

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

// Briques

module texte_brique() {
    if (niveau_detail >= 3) {
        // Texte place sur la face avant de la brique
        // Face avant = cote Y negatif
        color([0.08, 0.08, 0.08])
        translate([0, -profondeur_brique/2 + 0.05, 0])
            rotate([90, 0, 0])
                linear_extrude(height=0.5)
                    text(
                        "KittyWall",
                        size=4.2,
                        halign="center",
                        valign="center",
                        font="Liberation Sans:style=Bold"
                    );
    }
}

module brique_unique(r=0, c=0) {
    type_dalle = (r + c) % 4;

    if (type_dalle == 0)
        color([0.96, 0.96, 0.96])
            bloc_arrondi([largeur_brique, profondeur_brique, hauteur_brique], arrondi_brique());

    else if (type_dalle == 1)
        color([0.70, 0.82, 0.86])
            bloc_arrondi([largeur_brique, profondeur_brique, hauteur_brique], arrondi_brique());

    else if (type_dalle == 2)
        color([0.92, 0.80, 0.66])
            bloc_arrondi([largeur_brique, profondeur_brique, hauteur_brique], arrondi_brique());

    else
        color([0.98, 0.98, 0.98])
            bloc_arrondi([largeur_brique, profondeur_brique, hauteur_brique], arrondi_brique());

    texte_brique();
}

module rangee_briques(r) {
    largeur_r = largeur_rangee(r);
    n = nombre_briques_rangee(r);

    for (c = [0 : n - 1]) {
        x = -largeur_r/2
            + largeur_brique/2
            + c * (largeur_brique + espace_brique);

        translate([x, 0, 0])
            brique_unique(r, c);
    }
}

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
    // Les briques commencent directement sur la plateforme
    debut_z = hauteur_socle + hauteur_brique/2;

    for (r = [0 : nb_rangees_briques - 1]) {
        z = debut_z + r * (hauteur_brique + espace_brique);

        translate([0, 0, z]) {
            rangee_briques(r);
            dents_rangee(r);
        }
    }
}


// Montants latéraux forme escalier

module montant_lateral(gauche=true) {
    sens_x = gauche ? -1 : 1;

    // Position du montant principal
    position_montant_x = sens_x * (largeur_entre_montants()/2 + largeur_montant/2);

    // Montant vertical uniquement
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
