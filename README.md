# ZenLeave // POP & HEATMAP EDITION 🌴🚲

Application de gestion des congés et de suivi des déplacements à vélo, en style **Neo-Brutalism Pop** avec **Heatmap Annuelle 365 Jours**, **Frise Chronologique** et **gestion complète des demi-journées**.

---

## 🌓 Nouveauté : Gestion Complète des Demi-Journées (½ Jour)

Vous pouvez désormais poser des **demi-journées indépendantes** pour vos **Congés Payés (CP)**, **RTT** et **Congés Ancienneté** (ainsi que Maladie et Sans solde) :

### 1. Dans la Fiche du Jour (Clic sur un jour) :
- **Raccourcis en 1 clic** :
  - `🌴 Journée CP` | `🌅 ½ CP Matin` | `🌇 ½ CP Aprem`
  - `⚡ Journée RTT` | `🌅 ½ RTT Matin` | `🌇 ½ RTT Aprem`
  - `🎖️ Journée Anc.` | `🌅 ½ Anc. Matin` | `🌇 ½ Anc. Aprem`
- **Découpage indépendant Matin (0.5j) & Après-midi (0.5j)** :
  - Choisissez par exemple : **Matin = CP** (0.5j) et **Après-midi = Travaillé**.
  - Ou combinez deux motifs sur la même journée : **Matin = RTT** (0.5j) et **Après-midi = CP** (0.5j) !

### 2. Dans le Mode Pinceau Rapide (Pose en 1 Clic) :
Une rangée dédiée **« Demi-Jours (½j) »** vous permet de peindre directement :
- `🌅 ½ CP Matin` ou `🌇 ½ CP Aprem`
- `🌅 ½ RTT Matin` ou `🌇 ½ RTT Aprem`
- `🌅 ½ Anc. Matin` ou `🌇 ½ Anc. Aprem`
Cliquez sur n'importe quelle case de la Heatmap ou du Calendrier pour basculer la demi-journée correspondante !

### 3. Rendu Visuel Bicolore :
- **Sur la Heatmap 365 jours** : les demi-journées sont représentées par une **découpe bicolore verticale** (Matin à gauche / Après-midi à droite).
- **Sur le Calendrier** : affichage explicite de stickers distincts pour le Matin et l'Après-midi.
- **Sur les Compteurs & KPIs** : décompte précis par tranche de **0.5 jour** (ex: *24.5 restants*).
- **Sur les Exports Excel & PDF** : distinction nette entre 0.5j Matin, 0.5j Aprem et 1.0j Journée.

---

## 🚲 Suivi des Déplacements à Vélo (Sans Indemnité)
- **Comptage des trajets** : Jours à vélo, Aller-Retour ou Aller/Retour simple (0.5j trajet).
- **Statistiques écologiques & kilométriques** : Distance cumulée (km) et estimation du CO2 évité (kg).
- **Exports dédiés (PDF & Excel)** : Attestation sur l'honneur avec récapitulatif détaillé des dates, trajets et kilomètres parcourus, sans aucune mention d'indemnité financière ou monétaire.

---

## 🐘 Base de Données Cloud (PostgreSQL / Supabase)

L'application intègre une architecture **hybride Cloud / Offline-First** :
- **Sans configuration** : fonctionne instantanément en local avec le `localStorage` de votre navigateur.
- **Avec Supabase** : synchronisation temps réel de vos congés et trajets vélo dans une vraie base de données **PostgreSQL hébergée**, accessible depuis votre PC, smartphone ou tablette.

### Configuration en 2 minutes :
1. Créez un projet gratuit sur [Supabase.com](https://supabase.com).
2. Rendez-vous dans le menu **SQL Editor > New Query**, collez le contenu du fichier [`schema.sql`](file:///d:/Dev/IA/vacances/schema.sql) et cliquez sur **Run**.
3. Dans ZenLeave, cliquez sur le bouton **« Cloud DB »** dans la barre du haut :
   - Renseignez l'**URL du projet** (`https://xyz.supabase.co`).
   - Renseignez la **clé API publique (`anon key`)**.
   - Cliquez sur **« Tester & Enregistrer »**.
4. Vos soldes et journées sont désormais automatiquement synchronisés dans les tables PostgreSQL `zenleave_config` et `zenleave_days` !

---

## 🚀 Lancement
Double-cliquez sur `index.html` pour ouvrir l'application dans votre navigateur !
