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

---

## 🐙 Connexion Automatique via Variables GitHub (GitHub Actions & Pages)

Vous pouvez configurer vos identifiants Supabase directement dans les **Variables ou Secrets de votre dépôt GitHub**. Le workflow GitHub Actions ([`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)) injecte automatiquement ces clés lors du déploiement de l'application sur **GitHub Pages** !

### 1. Ajouter les Variables et Secrets sur GitHub :
1. Rendez-vous sur votre dépôt GitHub : **`https://github.com/ivankameneff-creator/conge-velo`**
2. Cliquez sur l'onglet **Settings** (Paramètres du dépôt).
3. Dans le menu de gauche, allez dans **Secrets and variables** > **Actions**.
4. Dans l'onglet **Variables** (ou **Secrets**), ajoutez :
   - **`SUPABASE_URL`** : l'URL de votre projet Supabase (ex: `https://votre-projet.supabase.co`)
   - **`SUPABASE_ANON_KEY`** : votre clé API publique `anon` (disponible dans Supabase > *Project Settings > API > anon / public*)
5. Dans l'onglet **Secrets**, ajoutez :
   - **`APP_PASSWORD`** : votre mot de passe secret pour déverrouiller l'accès au site et à la BDD.

---

## 🔐 Protection par Mot de Passe sur Dépôt Public

Même avec un dépôt **Public** et un site GitHub Pages accessible publiquement :
- **Écran de verrouillage automatique** : toute personne ouvrant le site fait face à un écran de verrouillage demandant le mot de passe.
- **Données masquées** : aucun calendrier, solde, nom ou trajet vélo n'est affiché sans le mot de passe.
- **Mémorisation de l'appareil** : cochez *« Mémoriser sur cet appareil »* pour ne pas avoir à retaper le mot de passe à chaque visite sur votre ordinateur ou smartphone personnel.
- **Bouton Verrouiller** : un bouton `Verrouiller` dans la barre du haut permet de reverrouiller l'accès en 1 clic.
- **Gestion dans l'application** : vous pouvez aussi définir, modifier ou retirer le mot de passe à tout moment depuis la modale **Base de données ☁️ > Mot de Passe d'Accès BDD**.

### 2. Activer GitHub Pages :
1. Dans **Settings** > **Pages** de votre dépôt GitHub.
2. Dans la section **Build and deployment > Source**, sélectionnez **« GitHub Actions »**.
3. À chaque `git push`, le site est automatiquement mis à jour et déployé avec la connexion Supabase active d'office, sans que vous ayez à ressaisir quoi que ce soit dans le navigateur !

---

## 🚀 Lancement en local
- Double-cliquez sur `index.html` pour ouvrir l'application dans votre navigateur.
- Pour tester la connexion Supabase en local sans GitHub Actions, vous pouvez copier [`supabase-config.sample.js`](supabase-config.sample.js) vers `supabase-config.js` et y renseigner vos identifiants.
