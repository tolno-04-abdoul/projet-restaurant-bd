-- =========================================
-- OCTROI DES PRIVILEGES POUR LE PROJET RESTAURANT
-- À EXÉCUTER AVEC UN COMPTE DBA
-- =========================================

-- Se connecter en tant que DBA
-- CONN sys/mot_de_passe AS SYSDBA;

-- 1. Créer l'utilisateur s'il n'existe pas
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM dba_users WHERE username = 'RESTAURANT';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE USER restaurant IDENTIFIED BY restaurant123';
        DBMS_OUTPUT.PUT_LINE('✓ Utilisateur RESTAURANT créé');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✓ Utilisateur RESTAURANT existe déjà');
    END IF;
END;
/

-- 2. Octroyer les privilèges de base
GRANT CONNECT TO restaurant;
GRANT RESOURCE TO restaurant;
GRANT CREATE SESSION TO restaurant;

-- 3. Octroyer les privilèges de création
GRANT CREATE TABLE TO restaurant;
GRANT CREATE VIEW TO restaurant;
GRANT CREATE PROCEDURE TO restaurant;
GRANT CREATE FUNCTION TO restaurant;
GRANT CREATE TRIGGER TO restaurant;
GRANT CREATE SEQUENCE TO restaurant;
GRANT CREATE SYNONYM TO restaurant;

-- 4. Octroyer les privilèges de modification
GRANT ALTER ANY TABLE TO restaurant;
GRANT DROP ANY TABLE TO restaurant;
GRANT INSERT ANY TABLE TO restaurant;
GRANT UPDATE ANY TABLE TO restaurant;
GRANT DELETE ANY TABLE TO restaurant;
GRANT SELECT ANY TABLE TO restaurant;

-- 5. Octroyer l'espace disque
ALTER USER restaurant QUOTA UNLIMITED ON USERS;

-- 6. Octroyer les privilèges d'exécution
GRANT EXECUTE ANY PROCEDURE TO restaurant;

-- 7. Vérification
SELECT 
    privilege,
    admin_option
FROM dba_sys_privs 
WHERE grantee = 'RESTAURANT'
ORDER BY privilege;

PROMPT ========================================
PROMPT ✓ Tous les privilèges ont été octroyés
PROMPT ========================================