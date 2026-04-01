-- =========================================
-- PROCEDURES STOCKEES
-- =========================================

-- Procédure 1: Passer une nouvelle commande
CREATE OR REPLACE PROCEDURE sp_creer_commande(
    p_id_serveur IN NUMBER,
    p_numero_table IN NUMBER,
    p_nombre_couverts IN NUMBER DEFAULT 1,
    p_id_client IN NUMBER DEFAULT NULL,
    p_commentaire IN VARCHAR2 DEFAULT NULL
) IS
    v_id_commande NUMBER;
BEGIN
    INSERT INTO commandes (id_client, id_serveur, numero_table, nombre_couverts, commentaire)
    VALUES (p_id_client, p_id_serveur, p_numero_table, p_nombre_couverts, p_commentaire)
    RETURNING id_commande INTO v_id_commande;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Commande n°' || v_id_commande || ' créée');
END sp_creer_commande;
/

-- Procédure 2: Ajouter un produit à une commande
CREATE OR REPLACE PROCEDURE sp_ajouter_produit(
    p_id_commande IN NUMBER,
    p_id_produit IN NUMBER,
    p_quantite IN NUMBER
) IS
    v_prix NUMBER;
BEGIN
    SELECT prix INTO v_prix FROM produits WHERE id_produit = p_id_produit;
    
    INSERT INTO details_commande (id_commande, id_produit, quantite, prix_unitaire)
    VALUES (p_id_commande, p_id_produit, p_quantite, v_prix);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Produit ajouté');
END sp_ajouter_produit;
/

-- Procédure 3: Effectuer un paiement
CREATE OR REPLACE PROCEDURE sp_payer_commande(
    p_id_commande IN NUMBER,
    p_montant IN NUMBER,
    p_mode_paiement IN VARCHAR2,
    p_id_caissier IN NUMBER
) IS
BEGIN
    INSERT INTO paiements (id_commande, montant, mode_paiement, id_caissier)
    VALUES (p_id_commande, p_montant, p_mode_paiement, p_id_caissier);
    
    UPDATE commandes SET statut = 'termine', id_caissier = p_id_caissier
    WHERE id_commande = p_id_commande;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Paiement effectué');
END sp_payer_commande;
/

-- Procédure 4: Annuler une commande
CREATE OR REPLACE PROCEDURE sp_annuler_commande(
    p_id_commande IN NUMBER
) IS
BEGIN
    UPDATE commandes SET statut = 'annule' WHERE id_commande = p_id_commande;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Commande annulée');
END sp_annuler_commande;
/

-- Procédure 5: Créer une réservation
CREATE OR REPLACE PROCEDURE sp_creer_reservation(
    p_id_client IN NUMBER,
    p_date_reservation IN DATE,
    p_heure_reservation IN VARCHAR2,
    p_nombre_personnes IN NUMBER
) IS
BEGIN
    INSERT INTO reservations (id_client, date_reservation, heure_reservation, nombre_personnes)
    VALUES (p_id_client, p_date_reservation, p_heure_reservation, p_nombre_personnes);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Réservation créée');
END sp_creer_reservation;
/

-- Procédure 6: Changer statut commande
CREATE OR REPLACE PROCEDURE sp_changer_statut(
    p_id_commande IN NUMBER,
    p_statut IN VARCHAR2
) IS
BEGIN
    UPDATE commandes SET statut = p_statut WHERE id_commande = p_id_commande;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Statut modifié');
END sp_changer_statut;
/

-- Procédure 7: Rapport de ventes
CREATE OR REPLACE PROCEDURE sp_rapport_ventes(
    p_date_debut IN DATE,
    p_date_fin IN DATE
) IS
    v_total NUMBER;
BEGIN
    SELECT SUM(montant) INTO v_total
    FROM paiements
    WHERE TRUNC(date_paiement) BETWEEN TRUNC(p_date_debut) AND TRUNC(p_date_fin);
    
    DBMS_OUTPUT.PUT_LINE('CA : ' || NVL(v_total, 0) || ' €');
END sp_rapport_ventes;
/

COMMIT;

                   [ Read 0 lines ]
^G Help      ^O Write Out ^F Where Is  ^K Cut
^X Exit      ^R Read File ^\ Replace   ^U Paste
