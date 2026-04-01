-- =========================================
-- GESTION DES DROITS ET SECURITE
-- =========================================

-- Création des rôles
CREATE ROLE role_admin;
CREATE ROLE role_serveur;
CREATE ROLE role_caissier;

-- Droits pour le rôle ADMIN
GRANT CONNECT, RESOURCE TO role_admin;
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER TO role_admin;
GRANT ALL ON utilisateurs TO role_admin;
GRANT ALL ON clients TO role_admin;
GRANT ALL ON produits TO role_admin;
GRANT ALL ON commandes TO role_admin;
GRANT ALL ON details_commande TO role_admin;
GRANT ALL ON paiements TO role_admin;
GRANT ALL ON reservations TO role_admin;

-- Droits pour le rôle SERVEUR
GRANT CONNECT TO role_serveur;
GRANT SELECT ON produits TO role_serveur;
GRANT SELECT ON clients TO role_serveur;
GRANT INSERT, SELECT, UPDATE ON commandes TO role_serveur;
GRANT INSERT, SELECT ON details_commande TO role_serveur;
GRANT INSERT, SELECT ON reservations TO role_serveur;

-- Droits pour le rôle CAISSIER
GRANT CONNECT TO role_caissier;
GRANT SELECT ON commandes TO role_caissier;
GRANT SELECT ON clients TO role_caissier;
GRANT SELECT ON produits TO role_caissier;
GRANT INSERT, SELECT ON paiements TO role_caissier;
GRANT UPDATE ON commandes TO role_caissier;

-- Vue sécurisée (masque les mots de passe)
CREATE OR REPLACE VIEW v_utilisateurs_public AS
SELECT id_user, nom, prenom, role, actif
FROM utilisateurs;

-- Fonction de vérification de connexion
CREATE OR REPLACE FUNCTION f_verifier_connexion(
    p_login VARCHAR2,
    p_mdp VARCHAR2
) RETURN NUMBER IS
    v_id NUMBER;
BEGIN
    SELECT id_user INTO v_id
    FROM utilisateurs
    WHERE login = p_login AND mot_de_passe = p_mdp AND actif = 1;
    
    UPDATE utilisateurs SET derniere_connexion = SYSDATE WHERE id_user = v_id;
    COMMIT;
    
    RETURN v_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END f_verifier_connexion;
/

-- Procédure de désactivation d'employé
CREATE OR REPLACE PROCEDURE sp_desactiver_employe(
    p_id_user NUMBER
) IS
BEGIN
    UPDATE utilisateurs SET actif = 0 WHERE id_user = p_id_user;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Employé désactivé');
END sp_desactiver_employe;
/

-- Procédure d'anonymisation client (RGPD)
CREATE OR REPLACE PROCEDURE sp_anonymiser_client(
    p_id_client NUMBER
) IS
BEGIN
    UPDATE clients
    SET nom = 'ANONYME',
        prenom = NULL,
        telephone = NULL,
        email = NULL,
        adresse = NULL
    WHERE id_client = p_id_client;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Client anonymisé');
END sp_anonymiser_client;
/

COMMIT;
