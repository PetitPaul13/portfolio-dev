# Fiche mémo client

Les réponses courtes à sortir face à un client. Chaque entrée : **la question**, **la phrase à retenir**, puis l'explication si le client creuse.

> Fiche tenue à jour au fil de la formation. Version anglaise à venir.

---

## Bases de données

### SQLite ou PostgreSQL pour n8n ?
**À retenir : « SQLite pour tester, PostgreSQL pour la production. »**
- SQLite est un simple fichier : quand plusieurs workflows écrivent en même temps, il bloque.
- Il ralentit quand l'historique des exécutions grossit.
- Il se sauvegarde mal pendant que n8n tourne.
- Le « mode queue » de n8n (des workers en plus quand l'activité augmente) exige PostgreSQL.

---

## Infrastructure

### C'est quoi Docker ? Pourquoi l'utiliser ?
**À retenir : « Votre outil tourne dans une boîte standard, identique chez moi, chez vous et sur le serveur. »**
- Un conteneur embarque l'application et tout ce dont elle a besoin. Fini le « ça marchait sur ma machine ».
- Docker Compose décrit plusieurs conteneurs en un fichier (n8n + base de données, par exemple) et les lance en une commande.
- Mise à jour et retour arrière simples : on change la version de l'image.

### C'est quoi WSL2 ?
**À retenir : « Un vrai Linux intégré à Windows. »**
- Docker repose sur des fonctions du noyau Linux. Sous Windows, Docker Desktop les obtient grâce à WSL2.
- Il faut les droits administrateur pour l'installer, ce qui est souvent bloqué sur un poste d'entreprise.

### Docker est-il déjà dans Windows ? Docker Desktop ou Docker Engine ?
**À retenir : « WSL2 fournit le Linux, Docker Engine fait tourner les conteneurs, Docker Desktop n'est qu'un emballage pratique. »**
- Windows n'inclut pas Docker : WSL2 fournit seulement un noyau Linux.
- **Docker Engine** est le moteur qui fait tourner les conteneurs. Il est libre et gratuit, et c'est lui qu'on trouve sur un serveur.
- **Docker Desktop** emballe le moteur avec une interface graphique et une intégration Windows. Il est payant pour les entreprises de plus de 250 salariés ou de plus de 10 M$ de chiffre d'affaires.
- Sur un serveur client (un VPS), on installe uniquement Docker Engine.

### Quel hébergeur pour un site WordPress de TPE ?
**À retenir : « o2switch par défaut : français, environ 7 € par mois, SSH et WP-CLI inclus. »**
- Hébergé en France, c'est un bon argument RGPD.
- L'accès SSH et WP-CLI permet d'automatiser la maintenance (sauvegardes, mises à jour).
- Hostinger est moins cher mais plus limité. Un VPS donne une liberté totale, mais demande plus d'administration.

---

## Sécurité et bonnes pratiques

### Pourquoi un environnement de test séparé ?
**À retenir : « On ne teste jamais sur vos vraies données. »**
- Un agent IA qui lit une boîte mail enverrait les vrais e-mails à un service externe.
- Une erreur dans un workflow de test ne doit jamais toucher les vrais fichiers ni les vrais clients.
- Les captures d'écran et les démos ne doivent montrer aucune donnée réelle.

### C'est quoi Mailpit ? Pourquoi ne pas envoyer de vrais e-mails pendant le développement ?
**À retenir : « Une fausse boîte mail locale : on teste 50 fois sans spammer personne. »**
- L'outil croit envoyer un vrai e-mail, mais Mailpit l'intercepte et l'affiche dans une page locale.
- Sans ça, chaque test raté part vraiment, et Gmail peut bloquer le compte pour spam.
- On bascule sur le vrai envoi seulement une fois le workflow validé.

### Pourquoi limiter qui peut utiliser Docker sur un serveur ?
**À retenir : « Avoir accès à Docker, c'est avoir les clés du serveur. »**
- Le moteur Docker tourne avec les droits root.
- Quiconque peut lui donner des ordres peut lancer un conteneur qui monte tout le disque du serveur, puis lire ou modifier n'importe quel fichier : mots de passe, clés SSH, configuration système.
- Donc on ne met dans le groupe `docker` que les personnes de confiance, comme on le ferait pour `sudo`.
- Pour aller plus loin : le mode « rootless » de Docker, qui fait tourner le moteur sans les droits root.

### Docker peut-il servir à une attaque (ransomware, minage) ?
**À retenir : « Docker mal configuré est une porte d'entrée connue, Docker bien configuré ne l'est pas. »**
- **Le risque réel :** une API Docker exposée sur Internet sans authentification (port 2375). Des robots scannent Internet en permanence pour les trouver. Ils y lancent des mineurs de cryptomonnaie, volent des données, ou chiffrent et suppriment des volumes contre rançon.
- **Autres vecteurs :** une image piégée téléchargée sur Docker Hub, un conteneur compromis qui a accès à `/var/run/docker.sock` (et donc au moteur entier), un compte du groupe `docker` volé.
- **Les protections :**
  - ne jamais exposer l'API Docker sur le réseau, ou seulement avec TLS ;
  - limiter le groupe `docker` aux personnes de confiance ;
  - ne pas monter `docker.sock` dans un conteneur sans une vraie raison ;
  - utiliser des images officielles, à jour, avec une version précise ;
  - monter les volumes en lecture seule quand c'est possible ;
  - **garder des sauvegardes hors ligne** (règle 3-2-1 : 3 copies, 2 supports, 1 hors site), la seule vraie parade contre un ransomware.
- **Argument face au client :** « Je vérifie que votre serveur n'est pas une des milliers de machines Docker ouvertes sur Internet, et que vos sauvegardes survivraient à un ransomware. »

### Où sont stockés les mots de passe et les clés API ?
**À retenir : « Jamais dans le code : dans un fichier secret, hors de Git. »**
- Les secrets vont dans un fichier `.env`, exclu du dépôt Git.
- Un `.env.example` documente les variables attendues, sans les vraies valeurs.
- Un scan anti-secrets tourne avant chaque commit.

### Données de santé et IA (kiné, médecin, etc.)
**À retenir : « Les données de santé ne partent pas chez un fournisseur d'IA sans cadre RGPD spécifique. »**
- Ce sont des données « sensibles » au sens du RGPD (article 9).
- Avant de les envoyer à une API d'IA, il faut une base légale, un contrat de sous-traitance et un hébergement adapté (HDS en France).
- On peut aussi anonymiser avant l'envoi, ou classer sans envoyer le contenu.

---

## IA

### Mon abonnement ChatGPT ou Claude suffit pour l'automatisation ?
**À retenir : « Non : l'abonnement sert au chat, l'automatisation passe par l'API, payée à l'usage. »**
- L'API est un service séparé (pour Claude : console.anthropic.com), facturé au nombre de tokens.
- Avec un modèle léger, trier 100 e-mails coûte quelques centimes.
- On fixe toujours une limite de dépense mensuelle.

### L'IA peut-elle répondre seule à mes clients ?
**À retenir : « L'IA prépare, l'humain valide. »**
- L'agent rédige un brouillon de réponse, mais rien n'est envoyé sans validation humaine.
- Ça évite les réponses fausses ou maladroites envoyées au nom de l'entreprise.

---

## Démos et portfolio

### Pourquoi ne pas laisser tout le monde tester les automatisations en ligne ?
**À retenir : « Une démo publique ouverte, c'est une facture d'API et du spam garantis. »**
- N'importe qui pourrait déclencher l'outil des milliers de fois, et chaque appel IA coûte.
- Bon compromis : des vidéos courtes, plus une seule démo live limitée en nombre de requêtes.
