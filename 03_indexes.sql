-- =========================================
-- CREATION DES INDEX POUR OPTIMISATION
-- =========================================

-- Index sur les colonnes fréquemment recherchées
CREATE INDEX idx_commandes_date ON commandes(date_commande);
CREATE INDEX idx_commandes_statut ON commandes(statut);
CREATE INDEX idx_commandes_client ON commandes(id_client);
CREATE INDEX idx_commandes_serveur ON commandes(id_serveur);

-- Index sur les détails de commande
CREATE INDEX idx_details_commande_id ON details_commande(id_commande);
CREATE INDEX idx_details_produit ON details_commande(id_produit);

-- Index sur les paiements
CREATE INDEX idx_paiements_date ON paiements(date_paiement);
CREATE INDEX idx_paiements_commande ON paiements(id_commande);
CREATE INDEX idx_paiements_mode ON paiements(mode_paiement);

-- Index sur les clients
CREATE INDEX idx_clients_telephone ON clients(telephone);
CREATE INDEX idx_clients_nom ON clients(nom, prenom);
CREATE INDEX idx_clients_email ON clients(email);

-- Index sur les produits
CREATE INDEX idx_produits_categorie ON produits(categorie);
CREATE INDEX idx_produits_disponible ON produits(disponible);
CREATE INDEX idx_produits_prix ON produits(prix);

-- Index sur les réservations
CREATE INDEX idx_reservations_date ON reservations(date_reservation);
CREATE INDEX idx_reservations_client ON reservations(id_client);
CREATE INDEX idx_reservations_statut ON reservations(statut);

-- Index composites pour les rapports fréquents
CREATE INDEX idx_commandes_date_statut ON commandes(date_commande, statut);
CREATE INDEX idx_paiements_date_mode ON paiements(date_paiement, mode_paiement);
CREATE INDEX idx_details_commande_complet ON details_commande(id_commande, id_produit);

COMMIT;