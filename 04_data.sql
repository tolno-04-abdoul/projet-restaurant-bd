-- =========================================
-- INSERTION DES DONNEES DE TEST
-- =========================================

-- Insertion des utilisateurs (mots de passe: 'password123' en hash simulé)
INSERT INTO utilisateurs (nom, prenom, role, login, mot_de_passe, actif) VALUES 
    ('Admin', 'System', 'admin', 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
    ('Dupont', 'Jean', 'serveur', 'jean.dupont', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
    ('Martin', 'Sophie', 'serveur', 'sophie.martin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
    ('Bernard', 'Pierre', 'caissier', 'pierre.bernard', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
    ('Petit', 'Marie', 'caissier', 'marie.petit', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 1),
    ('Dubois', 'Lucas', 'serveur', 'lucas.dubois', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 0);

-- Insertion des clients
INSERT INTO clients (nom, prenom, telephone, email, adresse, points_fidelite) VALUES 
    ('Laurent', 'Isabelle', '0612345678', 'isabelle.laurent@email.com', '12 rue de Paris, 75001 Paris', 150),
    ('Moreau', 'Thomas', '0623456789', 'thomas.moreau@email.com', '45 avenue des Fleurs, 69002 Lyon', 80),
    ('Simon', 'Julie', '0634567890', 'julie.simon@email.com', '8 boulevard Victor Hugo, 13001 Marseille', 200),
    ('Michel', 'Nicolas', '0645678901', 'nicolas.michel@email.com', '23 rue Nationale, 59000 Lille', 45),
    ('Lefevre', 'Camille', '0656789012', 'camille.lefevre@email.com', '67 cours Mirabeau, 13100 Aix-en-Provence', 320),
    ('Garcia', 'Antonio', '0667890123', 'antonio.garcia@email.com', '15 rue de la République, 31000 Toulouse', 95);

-- Insertion des produits (menu)
INSERT INTO produits (nom_produit, description, prix, categorie, sous_categorie, stock) VALUES 
    ('Entrées', NULL, NULL, 'entree', NULL, 0),
    ('Salade César', 'Salade romaine, poulet, parmesan, sauce César', 9.50, 'entree', 'salade', 50),
    ('Soupe à l''oignon', 'Soupe traditionnelle gratinée', 7.90, 'entree', 'soupe', 40),
    ('Foie gras', 'Foie gras de canard, pain d''épices', 14.90, 'entree', 'charcuterie', 30),
    
    ('Plats', NULL, NULL, 'plat', NULL, 0),
    ('Steak Frites', 'Steak de bœuf, frites maison', 18.50, 'plat', 'viande', 60),
    ('Magret de Canard', 'Magret de canard, sauce miel et épices', 22.90, 'plat', 'viande', 45),
    ('Saumon grillé', 'Filet de saumon, légumes de saison', 19.90, 'plat', 'poisson', 40),
    ('Pizza Margherita', 'Tomate, mozzarella, basilic', 12.90, 'plat', 'pizza', 35),
    ('Burger Maison', 'Bœuf, cheddar, salade, tomate, frites', 15.90, 'plat', 'burger', 55),
    
    ('Desserts', NULL, NULL, 'dessert', NULL, 0),
    ('Crème Brûlée', 'Crème vanille, caramel croustillant', 6.90, 'dessert', 'creme', 50),
    ('Fondant au Chocolat', 'Cœur coulant au chocolat noir', 7.50, 'dessert', 'gateau', 45),
    ('Tarte Tatin', 'Tarte aux pommes caramélisées', 6.50, 'dessert', 'tarte', 40),
    ('Profiteroles', 'Choux, glace vanille, sauce chocolat', 8.50, 'dessert', 'glace', 35),
    
    ('Boissons', NULL, NULL, 'boisson', NULL, 0),
    ('Café', 'Café expresso', 2.00, 'boisson', 'chaude', 200),
    ('Thé', 'Thé au choix', 2.50, 'boisson', 'chaude', 150),
    ('Jus d''orange', 'Jus frais pressé', 4.50, 'boisson', 'froide', 80),
    ('Coca-Cola', '33cl', 3.00, 'boisson', 'soda', 120),
    ('Eau minérale', '50cl', 2.00, 'boisson', 'eau', 300);

-- Insertion des commandes
INSERT INTO commandes (id_client, id_serveur, numero_table, nombre_couverts, statut, commentaire) VALUES 
    (1, 2, 5, 2, 'termine', 'Sans oignons pour une personne'),
    (2, 2, 3, 4, 'termine', NULL),
    (3, 3, 8, 2, 'servi', 'Anniversaire'),
    (NULL, 3, 12, 1, 'en_preparation', NULL),
    (4, 2, 2, 3, 'en_attente', NULL),
    (5, 3, 7, 2, 'termine', 'Sans gluten');

-- Insertion des détails de commande
INSERT INTO details_commande (id_commande, id_produit, quantite, prix_unitaire, remise) VALUES 
    (1, 2, 1, 9.50, 0),
    (1, 6, 2, 18.50, 0),
    (1, 12, 1, 6.90, 0),
    (1, 17, 2, 2.00, 0),
    
    (2, 4, 1, 14.90, 0),
    (2, 8, 2, 19.90, 5.00),
    (2, 9, 1, 12.90, 0),
    (2, 13, 3, 7.50, 0),
    
    (3, 3, 2, 7.90, 0),
    (3, 7, 2, 22.90, 0),
    (3, 14, 2, 8.50, 0),
    (3, 19, 4, 3.00, 0),
    
    (4, 5, 1, 18.50, 0),
    (4, 17, 1, 2.00, 0),
    
    (5, 2, 1, 9.50, 0),
    (5, 6, 1, 18.50, 0),
    (5, 10, 1, 15.90, 0),
    (5, 11, 1, 6.90, 0),
    
    (6, 8, 1, 19.90, 0),
    (6, 16, 2, 2.50, 0),
    (6, 12, 1, 6.90, 0);

-- Insertion des paiements
INSERT INTO paiements (id_commande, montant, mode_paiement, reference_transaction, id_caissier) VALUES 
    (1, 54.90, 'carte_credit', 'TRX001234', 4),
    (2, 85.20, 'especes', NULL, 4),
    (3, 92.60, 'carte_debit', 'TRX001235', 5),
    (6, 48.20, 'carte_credit', 'TRX001236', 4);

-- Insertion des réservations
INSERT INTO reservations (id_client, date_reservation, heure_reservation, nombre_personnes, numero_table, statut) VALUES 
    (1, SYSDATE + 1, '19:30', 4, 5, 'confirmée'),
    (2, SYSDATE + 2, '20:00', 2, 3, 'confirmée'),
    (3, SYSDATE + 1, '12:30', 6, 8, 'confirmée'),
    (4, SYSDATE + 3, '19:00', 3, 2, 'confirmée');