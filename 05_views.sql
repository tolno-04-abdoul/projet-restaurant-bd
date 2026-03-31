-- =========================================
-- CREATION DES VUES
-- =========================================

-- Vue 1: Commandes actives (non terminées)
CREATE OR REPLACE VIEW v_commandes_actives AS
SELECT 
    c.id_commande,
    c.numero_table,
    TO_CHAR(c.date_commande, 'DD/MM/YYYY HH24:MI') AS date_heure,
    c.statut,
    CASE WHEN c.id_client IS NULL THEN 'Client anonyme' 
         ELSE cl.nom || ' ' || cl.prenom END AS client,
    u.nom || ' ' || u.prenom AS serveur,
    (SELECT SUM(dc.quantite * dc.prix_unitaire - dc.remise) 
     FROM details_commande dc 
     WHERE dc.id_commande = c.id_commande) AS total_commande
FROM commandes c
LEFT JOIN clients cl ON c.id_client = cl.id_client
JOIN utilisateurs u ON c.id_serveur = u.id_user
WHERE c.statut NOT IN ('termine', 'annule')
ORDER BY c.date_commande DESC;

-- Vue 2: Chiffre d'affaires quotidien
CREATE OR REPLACE VIEW v_chiffre_affaires_jour AS
SELECT 
    TRUNC(date_paiement) AS jour,
    COUNT(DISTINCT id_commande) AS nb_commandes,
    SUM(montant) AS total_ca,
    ROUND(AVG(montant), 2) AS panier_moyen,
    COUNT(*) AS nb_paiements
FROM paiements
GROUP BY TRUNC(date_paiement)
ORDER BY jour DESC;

-- Vue 3: Chiffre d'affaires par mode de paiement
CREATE OR REPLACE VIEW v_ca_par_mode_paiement AS
SELECT 
    mode_paiement,
    COUNT(*) AS nb_transactions,
    SUM(montant) AS total,
    ROUND(AVG(montant), 2) AS montant_moyen
FROM paiements
GROUP BY mode_paiement
ORDER BY total DESC;

-- Vue 4: Top 10 des produits les plus vendus
CREATE OR REPLACE VIEW v_top_produits AS
SELECT 
    p.id_produit,
    p.nom_produit,
    p.categorie,
    SUM(dc.quantite) AS quantite_vendue,
    COUNT(DISTINCT dc.id_commande) AS nb_commandes,
    SUM(dc.quantite * dc.prix_unitaire) AS chiffre_affaires
FROM produits p
JOIN details_commande dc ON p.id_produit = dc.id_produit
JOIN commandes c ON dc.id_commande = c.id_commande
WHERE c.statut != 'annule'
    AND p.categorie IS NOT NULL
GROUP BY p.id_produit, p.nom_produit, p.categorie
ORDER BY chiffre_affaires DESC
FETCH FIRST 10 ROWS ONLY;

-- Vue 5: Performance des serveurs
CREATE OR REPLACE VIEW v_performance_serveurs AS
SELECT 
    u.id_user,
    u.nom,
    u.prenom,
    COUNT(DISTINCT c.id_commande) AS nb_commandes,
    COUNT(DISTINCT c.id_client) AS nb_clients_servis,
    NVL(SUM(p.montant), 0) AS total_ca_genere,
    NVL(ROUND(AVG(p.montant), 2), 0) AS panier_moyen
FROM utilisateurs u
LEFT JOIN commandes c ON u.id_user = c.id_serveur
LEFT JOIN paiements p ON c.id_commande = p.id_commande
WHERE u.role = 'serveur' AND c.statut = 'termine'
GROUP BY u.id_user, u.nom, u.prenom
ORDER BY total_ca_genere DESC;

-- Vue 6: Fidélité clients
CREATE OR REPLACE VIEW v_fidelite_clients AS
SELECT 
    cl.id_client,
    cl.nom,
    cl.prenom,
    cl.telephone,
    cl.points_fidelite,
    COUNT(c.id_commande) AS nb_commandes,
    NVL(SUM(p.montant), 0) AS total_depenses,
    NVL(ROUND(AVG(p.montant), 2), 0) AS panier_moyen,
    CASE 
        WHEN cl.points_fidelite >= 300 THEN 'Platine'
        WHEN cl.points_fidelite >= 150 THEN 'Or'
        WHEN cl.points_fidelite >= 50 THEN 'Argent'
        ELSE 'Bronze'
    END AS statut_fidelite
FROM clients cl
LEFT JOIN commandes c ON cl.id_client = c.id_client AND c.statut = 'termine'
LEFT JOIN paiements p ON c.id_commande = p.id_commande
GROUP BY cl.id_client, cl.nom, cl.prenom, cl.telephone, cl.points_fidelite
ORDER BY total_depenses DESC;

-- Vue 7: Réservations à venir
CREATE OR REPLACE VIEW v_reservations_avenir AS
SELECT 
    r.id_reservation,
    r.date_reservation,
    r.heure_reservation,
    r.nombre_personnes,
    r.numero_table,
    cl.nom || ' ' || cl.prenom AS client,
    cl.telephone,
    r.statut,
    r.commentaire
FROM reservations r
JOIN clients cl ON r.id_client = cl.id_client
WHERE r.date_reservation >= TRUNC(SYSDATE)
    AND r.statut = 'confirmée'
ORDER BY r.date_reservation, r.heure_reservation;

-- Vue 8: État des stocks
CREATE OR REPLACE VIEW v_etat_stocks AS
SELECT 
    id_produit,
    nom_produit,
    categorie,
    sous_categorie,
    prix,
    stock,
    disponible,
    CASE 
        WHEN stock = 0 THEN 'RUPTURE DE STOCK'
        WHEN stock < 10 THEN 'STOCK FAIBLE'
        WHEN stock < 30 THEN 'STOCK MOYEN'
        ELSE 'STOCK SUFFISANT'
    END AS alerte_stock,
    CASE 
        WHEN disponible = 0 THEN 'INDISPONIBLE'
        ELSE 'DISPONIBLE'
    END AS disponibilite
FROM produits
WHERE categorie IS NOT NULL
ORDER BY 
    CASE alerte_stock
        WHEN 'RUPTURE DE STOCK' THEN 1
        WHEN 'STOCK FAIBLE' THEN 2
        ELSE 3
    END,
    categorie,
    nom_produit;

-- Vue 9: Commandes du jour
CREATE OR REPLACE VIEW v_commandes_jour AS
SELECT 
    c.id_commande,
    c.numero_table,
    TO_CHAR(c.date_commande, 'HH24:MI') AS heure,
    c.statut,
    CASE WHEN c.id_client IS NULL THEN 'Anonyme' 
         ELSE cl.nom || ' ' || cl.prenom END AS client,
    u.nom || ' ' || u.prenom AS serveur,
    (SELECT SUM(dc.quantite * dc.prix_unitaire - dc.remise) 
     FROM details_commande dc 
     WHERE dc.id_commande = c.id_commande) AS total,
    (SELECT COUNT(*) FROM details_commande dc WHERE dc.id_commande = c.id_commande) AS nb_articles
FROM commandes c
LEFT JOIN clients cl ON c.id_client = cl.id_client
JOIN utilisateurs u ON c.id_serveur = u.id_user
WHERE TRUNC(c.date_commande) = TRUNC(SYSDATE)
ORDER BY c.date_commande DESC;

-- Vue 10: Statistiques mensuelles
CREATE OR REPLACE VIEW v_stats_mensuelles AS
SELECT 
    TO_CHAR(date_paiement, 'YYYY-MM') AS mois,
    COUNT(DISTINCT id_commande) AS nb_commandes,
    SUM(montant) AS chiffre_affaires,
    ROUND(AVG(montant), 2) AS panier_moyen,
    COUNT(DISTINCT id_caissier) AS nb_caissiers_actifs
FROM paiements
GROUP BY TO_CHAR(date_paiement, 'YYYY-MM')
ORDER BY mois DESC;

COMMIT;