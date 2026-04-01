-- =========================================
-- REQUETES D'ANALYSE
-- =========================================

-- 1. Commandes actives
SELECT 
    c.id_commande,
    c.numero_table,
    c.statut,
    u.nom || ' ' || u.prenom AS serveur,
    (SELECT SUM(quantite * prix_unitaire) FROM details_commande WHERE id_commande = c.id_commande) AS total
FROM commandes c
JOIN utilisateurs u ON c.id_serveur = u.id_user
WHERE c.statut NOT IN ('termine', 'annule');

-- 2. Chiffre d'affaires par jour
SELECT 
    TRUNC(date_paiement) AS jour,
    COUNT(*) AS nb_ventes,
    SUM(montant) AS total_ca
FROM paiements
GROUP BY TRUNC(date_paiement)
ORDER BY jour DESC;

-- 3. Top produits
SELECT 
    p.nom_produit,
    SUM(dc.quantite) AS quantite_vendue,
    SUM(dc.quantite * dc.prix_unitaire) AS ca
FROM produits p
JOIN details_commande dc ON p.id_produit = dc.id_produit
JOIN commandes c ON dc.id_commande = c.id_commande
WHERE c.statut = 'termine'
GROUP BY p.nom_produit
ORDER BY ca DESC
FETCH FIRST 5 ROWS ONLY;

-- 4. Performance serveurs
SELECT 
    u.nom || ' ' || u.prenom AS serveur,
    COUNT(c.id_commande) AS nb_commandes,
    SUM(p.montant) AS total_ca
FROM utilisateurs u
LEFT JOIN commandes c ON u.id_user = c.id_serveur
LEFT JOIN paiements p ON c.id_commande = p.id_commande
WHERE u.role = 'serveur'
GROUP BY u.id_user, u.nom, u.prenom
ORDER BY total_ca DESC;

-- 5. Clients fidèles
SELECT 
    cl.nom || ' ' || cl.prenom AS client,
    COUNT(c.id_commande) AS nb_commandes,
    SUM(p.montant) AS total_depenses,
    cl.points_fidelite
FROM clients cl
LEFT JOIN commandes c ON cl.id_client = c.id_client AND c.statut = 'termine'
LEFT JOIN paiements p ON c.id_commande = p.id_commande
GROUP BY cl.id_client, cl.nom, cl.prenom, cl.points_fidelite
ORDER BY total_depenses DESC
FETCH FIRST 5 ROWS ONLY;

-- 6. Réservations du jour
SELECT 
    cl.nom || ' ' || cl.prenom AS client,
    r.heure_reservation,
    r.nombre_personnes,
    r.numero_table
FROM reservations r
JOIN clients cl ON r.id_client = cl.id_client
WHERE r.date_reservation = TRUNC(SYSDATE)
ORDER BY r.heure_reservation;

-- 7. Produits en rupture de stock
SELECT nom_produit, stock
FROM produits
WHERE stock = 0 AND disponible = 1;

-- 8. Détail d'une commande
SELECT 
    p.nom_produit,
    dc.quantite,
    dc.prix_unitaire,
    (dc.quantite * dc.prix_unitaire) AS total
FROM details_commande dc
JOIN produits p ON dc.id_produit = p.id_produit
WHERE dc.id_commande = 1;

-- 9. CA par mode de paiement
SELECT 
    mode_paiement,
    COUNT(*) AS nb,
    SUM(montant) AS total
FROM paiements
GROUP BY mode_paiement;

-- 10. Statistiques mensuelles
SELECT 
    TO_CHAR(date_paiement, 'YYYY-MM') AS mois,
    SUM(montant) AS ca
FROM paiements
GROUP BY TO_CHAR(date_paiement, 'YYYY-MM')
ORDER BY mois DESC;
