// Chat assis

// Paramètres principaux

// Taille globale du chat (hauteur totale en mm)
hauteur_chat = 60;

// Largeur du corps (en mm)
largeur_corps = 30;

// Taille des oreilles (hauteur en mm)
taille_oreilles = 12;

// Longueur de la queue (en mm)
longueur_queue = 30;

// Niveau de détail : 1 = basique, 2 = intermédiaire, 3 = détaillé
niveau_detail = 3;

// Résolution des surfaces courbes
$fn = 60;

// Module principal

module chat(h, l, oreilles, queue, niveau) {
    
    // Dimensions dérivées
    rayon_corps = l / 2;
    rayon_tete = h * 0.22;
    hauteur_corps = h * 0.55;
    pos_tete_z = h - rayon_tete;
    
    // Assemblage : tout est dans un seul difference()
    // pour garantir la fusion des additions et des gravures
    
    difference() {
        // parties solides (additions)
        union() {
            
            // corps (forme de poire, base plate)
            hull() {
                cylinder(h = 2, r = rayon_corps);
                translate([0, 0, hauteur_corps - rayon_corps * 0.7])
                    sphere(r = rayon_corps * 0.7);
            }
            
            // tête (sphère qui s'enfonce dans le corps)
            translate([0, 0, pos_tete_z - 2])
                sphere(r = rayon_tete);
            
            // oreilles (niveau 2 et 3)
            
            if (niveau >= 2) {
                translate([-rayon_tete * 0.55, 0, pos_tete_z + rayon_tete * 0.20])
                    rotate([0, -20, 0])
                        cylinder(h = oreilles, r1 = oreilles * 0.45, r2 = 0);
                translate([rayon_tete * 0.55, 0, pos_tete_z + rayon_tete * 0.20])
                    rotate([0, 20, 0])
                        cylinder(h = oreilles, r1 = oreilles * 0.45, r2 = 0);
            }
            
            // queue (niveau 2 et 3)
            if (niveau >= 2) {
                translate([rayon_corps * 0.7, 0, hauteur_corps * 0.4])
                    rotate([0, 70, 0])
                        cylinder(h = queue, r1 = 4, r2 = 2.5);
            }
            
            // pattes avant (niveau 2 et 3)
            if (niveau >= 2) {
                translate([-rayon_corps * 0.4, rayon_corps * 0.5, 0])
                    cylinder(h = h * 0.22, r = 4);
                translate([rayon_corps * 0.4, rayon_corps * 0.5, 0])
                    cylinder(h = h * 0.22, r = 4);
            }
            
            // museau (niveau 3 uniquement)
            if (niveau >= 3) {
                translate([0, rayon_tete * 0.85, pos_tete_z - rayon_tete * 0.1])
                    sphere(r = rayon_tete * 0.25);
            }
            
            // yeux en relief (niveau 3 uniquement)
            if (niveau >= 3) {
                translate([-rayon_tete * 0.4, rayon_tete * 0.75, pos_tete_z + rayon_tete * 0.15])
                    sphere(r = rayon_tete * 0.18);
                translate([rayon_tete * 0.4, rayon_tete * 0.75, pos_tete_z + rayon_tete * 0.15])
                    sphere(r = rayon_tete * 0.18);
            }
        }
        
        // gravures en creux (soustractions)
        if (niveau >= 3) {
            
            // Oreille gauche
            translate([-rayon_tete * 0.55, 1.5, pos_tete_z + rayon_tete * 0.20 + 1])
                rotate([0, -20, 0])
                    cylinder(h = oreilles * 0.85, r1 = oreilles * 0.30, r2 = 0);
            // Oreille droite
            translate([rayon_tete * 0.55, 1.5, pos_tete_z + rayon_tete * 0.20 + 1])
                rotate([0, 20, 0])
                    cylinder(h = oreilles * 0.85, r1 = oreilles * 0.30, r2 = 0);
            
            // bouche gravée
            translate([0,
                       rayon_tete * 0.95,
                       pos_tete_z - rayon_tete * 0.45])
                rotate([0, 90, 0])
                    cylinder(h = 5, r = 0.5, center = true);
            
            
            // moustaches gravées
            // 3 moustaches à gauche
            for (i = [0, 1, 2]) {
                translate([-rayon_tete * 0.50,
                           rayon_tete * 0.78,
                           pos_tete_z - rayon_tete * 0.15 + (i - 1) * 2.0])
                    rotate([0, 90, 25])
                        cylinder(h = 7, r = 0.45, center = true);
            }
            // 3 moustaches à droite
            for (i = [0, 1, 2]) {
                translate([rayon_tete * 0.50,
                           rayon_tete * 0.78,
                           pos_tete_z - rayon_tete * 0.15 + (i - 1) * 2.0])
                    rotate([0, 90, -25])
                        cylinder(h = 7, r = 0.45, center = true);
            }
        }
    }
}

// appel du module

chat(hauteur_chat, largeur_corps, taille_oreilles, longueur_queue, niveau_detail);

// Si besoin affichage des trois niveaux de detail
//translate([-80, 0, 0])
// chat(hauteur_chat, largeur_corps, taille_oreilles, longueur_queue, 1);
// chat(hauteur_chat, largeur_corps, taille_oreilles, longueur_queue, 2);
// translate([80, 0, 0])
chat(hauteur_chat, largeur_corps, taille_oreilles, longueur_queue, 3);
