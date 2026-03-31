<<<<<<< HEAD
# 🍽️ Système de Gestion de Restaurant

[![Oracle](https://img.shields.io/badge/Oracle-11g+-red.svg)](https://www.oracle.com/database/)
[![SQL](https://img.shields.io/badge/SQL-PL%2FSQL-orange.svg)](https://www.oracle.com/database/technologies/appdev/plsql.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Description

Projet de base de données pour la gestion complète d'un restaurant.  
Développé dans le cadre du cours de **Base de Données**.

### Fonctionnalités
- ✅ Gestion des utilisateurs (admin, serveur, caissier)
- ✅ Gestion des commandes et des détails
- ✅ Gestion des paiements et de la fidélité
- ✅ Gestion des réservations
- ✅ Rapports et statistiques (vues)
- ✅ Procédures stockées métier
- ✅ Gestion des droits et sécurité

---

## 🗄️ Structure de la base de données

### Tables
| Table | Description |
|-------|-------------|
| `utilisateurs` | Employés du restaurant |
| `clients` | Clients et points de fidélité |
| `produits` | Menu et stocks |
| `commandes` | Commandes passées |
| `details_commande` | Lignes de commande |
| `paiements` | Transactions financières |
| `reservations` | Réservations de tables |
| `audit_log` | Journal d'audit |

### Relations
clients (1) ────── (0,n) commandes
utilisateurs (1) ── (0,n) commandes
produits (1) ────── (0,n) details_commande
commandes (1) ───── (1,n) details_commande
commandes (1) ───── (0,1) paiements

---

## 🚀 Installation

### Prérequis
- Oracle Database 11g ou supérieur
- SQL*Plus ou Oracle SQL Developer

### Procédure d'installation

1. **Cloner le dépôt**
```bash
git clone https://github.com/votre-compte/projet-restaurant-bd.git
cd projet-restaurant-bd
=======
# projet-restaurant-bd
projet-restaurant-bd
>>>>>>> d9d12f6aab55f9242435714820f61dd9836b46e8
