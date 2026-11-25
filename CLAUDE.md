# Portfolio Dev : n8n, Make, WordPress

## Le projet
Portfolio personnel et montée en compétences sur n8n, Make et WordPress, à travers 3 projets démonstratifs :
1. automatisations et agents IA pour TPE/PME ;
2. site vitrine ;
3. maintenance et sécurité de site.

Paul est ingénieur (ESILV 2025) et travaille en cybersécurité.

## Le niveau de Paul
- **Maîtrise :** Python, JS/Node, React, React Native (Expo), Supabase/PostgreSQL, Docker, Git, API Claude/OpenAI.
- **Débutant complet :** n8n, Make et WordPress.

## Comment travailler avec Paul
- Rôle de mentor : avant chaque étape, expliquer le concept et son intérêt chez un client, puis faire l'étape avec lui. Poser de petites questions de vérification.
- Une étape à la fois, avec un résultat testable. Demander avant toute installation.
- Données 100 % fictives. Aucune donnée réelle de client ni de l'employeur.
- Secrets dans `.env` (hors Git), avec un `.env.example` documenté.
- Tout en local avec Docker Compose quand c'est possible.
- **Tenir à jour `notes/fiche-memo-client.md`** : chaque question de Paul devient une entrée (question, phrase à retenir, explication).
- Livrables en français ET en anglais.

## Décisions prises
- **Entreprise fictive :** agence immobilière (nom à choisir). Pas de cabinet de kiné, à cause des données de santé et du RGPD.
- **Repo GitHub public**, avec un `.gitignore` strict et un scan anti-secrets avant chaque commit.
- **Compte Google dédié aux tests** pour Gmail et Sheets (Paul le crée).
- **API Anthropic** sur console.anthropic.com, avec une limite de dépense. Modèle léger (Haiku) pour le tri.
- **Mailpit** (conteneur) pour les e-mails pendant le développement, puis le vrai Gmail de test pour les démos.
- **Hébergement de référence pour WordPress :** o2switch. Scripts de maintenance portables (SSH + WP-CLI).
- **Système complet relié :**
  - le formulaire WordPress déclenche le workflow n8n (a) ;
  - le workflow n8n (c) résume les leads et le tri de la semaine ;
  - le rapport de maintenance WordPress est envoyé par n8n ;
  - Make refait le workflow (a) pour comparer les deux outils.
- **Portfolio interactif : après dimanche.** Il comprendra des vidéos courtes, une seule démo live limitée en nombre de requêtes, et WordPress Playground pour le site.

## Vision du repo : un produit fini, pas un carnet d'exercices
- Le repo sera **renommé** et présenté comme **un produit** : la suite d'automatisation d'une agence immobilière fictive, propre et soignée. Les brouillons et exercices ne doivent pas être mis en avant.
- Recommandation : garder le repo **privé** pendant la construction, puis le passer en public une fois le README vitrine prêt.
- **Avant publication :** retirer `labs/` et `notes/` du repo public (ou les déplacer dans un repo privé), puis relire l'historique Git.

## Structure du repo
```
.
├── README.md            vitrine du produit (FR/EN), à écrire en fin de parcours
├── CLAUDE.md            contexte et avancement (pour Claude)
├── .githooks/           pre-commit gitleaks
├── n8n/                 stack Docker + workflows « produit »
│   ├── docker-compose.yml, .env.example
│   ├── scripts/         export-workflows.sh
│   └── workflows/       workflows livrables uniquement (01-, 02-, 03-, 99-erreurs)
├── make/                blueprint Make + fiche comparative
├── wordpress/           stack Docker, thème, kit de maintenance
├── labs/                exercices d'apprentissage (hello world...) : hors produit
└── notes/               notes perso de Paul (fiche mémo client) : hors produit
```
- Nommage des workflows dans n8n : `01 - ...`, `02 - ...` pour le produit. `00 - ...` ou `LAB - ...` pour les exercices : le script d'export les range automatiquement dans `labs/n8n/`.

## Planning (objectif : portfolio complet le dimanche 29/11/2026)
| Jour | Objectif |
|---|---|
| Mar–Mer | Installation, n8n, workflows (a) et (b) |
| Jeu | Workflow (c), gestion des erreurs, Make (a) et fiche comparative |
| Ven | Site WordPress et formulaire relié à n8n |
| Sam | Kit de maintenance : sauvegardes, mises à jour, durcissement, rapport |
| Dim | README FR/EN, fiches portfolio, captures, mise à jour de ce fichier |

## Avancement
- [x] Plan validé, questions répondues (24/11/2026).
- [x] Fiche mémo client créée (déplacée dans `notes/` le 25/11).
- [ ] **Étape 0 :** environnement Docker, puis `git init`. Git 2.56 est déjà présent.
  - [x] WSL2 installé par la DSI (WSL 3.0.5).
  - [x] Ubuntu dans WSL, avec systemd activé.
  - [x] **Docker Engine 29.10 + Compose v5.8** installés dans Ubuntu depuis le dépôt officiel Docker. Pas de Docker Desktop, pour éviter la question de licence.
  - [x] Tests OK : `hello-world`, et un port publié est joignable depuis Windows sur `localhost`.
  - [x] Utilisateur Linux `paul` (groupes `sudo` et `docker`), défini comme utilisateur par défaut dans `/etc/wsl.conf`.
  - Les commandes Docker se lancent dans Ubuntu (`wsl -d Ubuntu`). Le projet reste sur `C:\Perso\Portfolio Dev`, vu comme `/mnt/c/Perso/Portfolio Dev` depuis Ubuntu.
- [x] `git init`, `.gitignore` strict, `.gitattributes` (fins de ligne LF). Premier commit `34aab8a` poussé sur `main` le 24/11. Ensuite : une branche par étape (`n8n/hello-world`, `n8n/workflow-a`...).
- [ ] Projet 1 : n8n.
  - [x] 1.1 `n8n/docker-compose.yml` : n8n 2.49.5 + PostgreSQL 17 + Mailpit.
    - Ports liés à `127.0.0.1` uniquement ; PostgreSQL n'est pas exposé.
    - Volumes nommés `postgres_data` et `n8n_data`. La persistance après `down`/`up` est testée et fonctionne.
    - `n8n/.env` est généré avec des secrets aléatoires (ignoré par Git) ; `n8n/.env.example` est documenté.
    - Image `n8nio/n8n` depuis Docker Hub : `docker.n8n.io` répondait 502 le 24/11.
    - Lancer : `wsl`, puis `cd "/mnt/c/Perso/Portfolio Dev/n8n"`, puis `docker compose up -d`. Interface n8n sur http://localhost:5678, Mailpit sur http://localhost:8025.
  - [x] Compte propriétaire n8n créé par Paul.
  - [x] 1.2 Concepts n8n et workflow « hello world » (25/11). Paul l'a construit seul avec le guide : Manual Trigger → Edit Fields → Send Email (credential SMTP « SMTP account » : host `mailpit`, port 1025, sans TLS). E-mail reçu dans Mailpit.
    - Export : `bash scripts/export-workflows.sh` (dans WSL, dossier `n8n`). Produit → `n8n/workflows/`, exercices → `labs/n8n/`. Les credentials ne sont pas exportés, seulement leur nom et leur id.
  - [ ] 1.3 Workflow (a) : formulaire → Google Sheets → confirmation au prospect → notification à l'agent.
- [x] Repo GitHub : https://github.com/PetitPaul13/portfolio-dev (remote `origin`). Un seul repo pour les 3 projets.
- [x] Scan anti-secrets : `.githooks/pre-commit` lance gitleaks v8.30.0 dans Docker (via WSL), activé par `git config core.hooksPath .githooks`.
  - Testé : bloque un faux token GitHub, laisse passer le contenu propre.
  - À refaire sur une nouvelle machine : `git config core.hooksPath .githooks`.
- **Piège Windows :** PowerShell 5.1 abîme les accents (UTF-8 lu comme ANSI). Modifier les fichiers avec les outils d'édition ou dans WSL, jamais avec `Get-Content`/`Set-Content`.
- [ ] **Plus tard :** fiche pédagogique « Comprendre Docker » à déposer sur le Google Drive **perso** de Paul.
  - Contenu : image, conteneur, Dockerfile, registre, volume, réseau, Compose, isolation par le noyau Linux (namespaces, cgroups), différence avec une VM, sécurité (groupe `docker` ≈ root).
  - En français, avec des schémas visuels (pas en texte), dont le schéma « VM vs conteneurs » et le tableau image/conteneur/registre/volume.
- [ ] **Plus tard :** module « Sécurité Docker et conteneurs ».
  - Pratique : passer Docker en mode rootless, API Docker protégée par TLS, risques de `docker.sock`, images fiables, volumes en lecture seule, sauvegardes hors ligne 3-2-1.
  - À relier au kit de maintenance du projet 3 (argument de vente).
- [ ] Projet 2 : Make.
- [ ] Projet 3 : WordPress.
