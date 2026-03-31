-- =========================================
-- AJOUT DES CONTRAINTES (FOREIGN KEYS ET CHECK)
-- =========================================

-- Contraintes pour commandes
ALTER TABLE commandes ADD CONSTRAINT fk_commandes_client 
    FOREIGN KEY (id_client) REFERENCES clients(id_client);
    
ALTER TABLE commandes ADD CONSTRAINT fk_commandes_serveur 
    FOREIGN KEY (id_serveur) REFERENCES utilisateurs(id_user);
    
ALTER TABLE commandes ADD CONSTRAINT fk_commandes_caissier 
    FOREIGN KEY (id_caissier) REFERENCES utilisateurs(id_user);
    
ALTER TABLE commandes ADD CONSTRAINT chk_commande_statut 
    CHECK (statut IN ('en_attente', 'en_preparation', 'servi', 'termine', 'annule'));
    
ALTER TABLE commandes ADD CONSTRAINT chk_table_positive 
    CHECK (numero_table > 0);

-- Contraintes pour details_commande
ALTER TABLE details_commande ADD CONSTRAINT fk_details_commande 
    FOREIGN KEY (id_commande) REFERENCES commandes(id_commande) ON DELETE CASCADE;
    
ALTER TABLE details_commande ADD CONSTRAINT fk_details_produit 
    FOREIGN KEY (id_produit) REFERENCES produits(id_produit);
    
ALTER TABLE details_commande ADD CONSTRAINT chk_quantite_positive 
    CHECK (quantite > 0);
    
ALTER TABLE details_commande ADD CONSTRAINT chk_remise_valide 
    CHECK (remise >= 0 AND remise <= prix_unitaire * quantite);

-- Contraintes pour paiements
ALTER TABLE paiements ADD CONSTRAINT fk_paiements_commande 
    FOREIGN KEY (id_commande) REFERENCES commandes(id_commande);
    
ALTER TABLE paiements ADD CONSTRAINT fk_paiements_caissier 
    FOREIGN KEY (id_caissier) REFERENCES utilisateurs(id_user);
    
ALTER TABLE paiements ADD CONSTRAINT chk_mode_paiement 
    CHECK (mode_paiement IN ('especes', 'carte_credit', 'carte_debit', 'cheque', 'virement', 'mobile'));
    
ALTER TABLE paiements ADD CONSTRAINT chk_montant_positif 
    CHECK (montant > 0);

-- Contraintes pour reservations
ALTER TABLE reservations ADD CONSTRAINT fk_reservations_client 
    FOREIGN KEY (id_client) REFERENCES clients(id_client);
    
ALTER TABLE reservations ADD CONSTRAINT chk_reservation_statut 
    CHECK (statut IN ('confirmée', 'annulée', 'terminée'));
    
ALTER TABLE reservations ADD CONSTRAINT chk_nombre_personnes 
    CHECK (nombre_personnes > 0);

-- Contraintes pour utilisateurs
ALTER TABLE utilisateurs ADD CONSTRAINT chk_role 
    CHECK (role IN ('admin', 'serveur', 'caissier'));
    
ALTER TABLE utilisateurs ADD CONSTRAINT chk_actif 
    CHECK (actif IN (0, 1));

-- Contraintes pour produits
ALTER TABLE produits ADD CONSTRAINT chk_prix_positif 
    CHECK (prix >= 0);
    
ALTER TABLE produits ADD CONSTRAINT chk_disponible 
    CHECK (disponible IN (0, 1));
    
ALTER TABLE produits ADD CONSTRAINT chk_stock_positif 
    CHECK (stock >= 0);

-- Contraintes pour clients
ALTER TABLE clients ADD CONSTRAINT chk_points_fidelite 
    CHECK (points_fidelite >= 0);

-- Ajout de contraintes NOT NULL manquantes
ALTER TABLE commandes MODIFY id_serveur NOT NULL;
ALTER TABLE details_commande MODIFY quantite NOT NULL;
ALTER TABLE details_commande MODIFY prix_unitaire NOT NULL;
ALTER TABLE paiements MODIFY montant NOT NULL;
ALTER TABLE paiements MODIFY mode_paiement NOT NULL;
ALTER TABLE reservations MODIFY date_reservation NOT NULL;
ALTER TABLE reservations MODIFY heure_reservation NOT NULL;
ALTER TABLE reservations MODIFY nombre_personnes NOT NULL;

COMMIT;