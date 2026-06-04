// KittyWall - une seule brique
// Compatible OpenSCAD 2021.01
// Unites : millimetres

// Niveaux de details :
// 1 = brique simple
// 2 = brique avec coins legerement arrondis
// 3 = brique arrondie + texte "KittyWall"
niveau_detail = 3;

largeur_brique = 34;
hauteur_brique = 12;
profondeur_brique = 23;

// Qualite de rendu
$fn = niveau_detail == 1 ? 20 :
      niveau_detail == 2 ? 40 : 64;

// Arrondi de la brique
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

module brique_unique() {
    color([0.96, 0.96, 0.96])
        bloc_arrondi(
            [largeur_brique, profondeur_brique, hauteur_brique],
            arrondi_brique()
        );

    texte_brique();
}

// Assemblage

brique_unique();
