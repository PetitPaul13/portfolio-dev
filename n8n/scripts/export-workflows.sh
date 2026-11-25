#!/bin/bash
# Exporte tous les workflows n8n en JSON (un fichier par workflow).
#   - Workflows « produit »  -> n8n/workflows/
#   - Exercices d'apprentissage (nom commençant par "00" ou "LAB") -> labs/n8n/
# Usage (dans Ubuntu/WSL, depuis le dossier n8n) :  bash scripts/export-workflows.sh
# Les credentials ne sont PAS exportés : seuls leur nom et leur id apparaissent dans les fichiers.
set -euo pipefail
cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

docker compose exec -T n8n sh -c 'rm -rf /tmp/wf && mkdir -p /tmp/wf && n8n export:workflow --all --pretty --separate --output=/tmp/wf/' < /dev/null
docker compose cp n8n:/tmp/wf/. "$tmp/" >/dev/null
mkdir -p ./workflows ../labs/n8n

# Renomme chaque fichier d'après le nom du workflow ("01 - Formulaire de contact" -> 01-formulaire-de-contact.json)
for f in "$tmp"/*.json; do
  name=$(python3 -c 'import json,sys,re,unicodedata; n=json.load(open(sys.argv[1]))["name"]; n=unicodedata.normalize("NFKD",n).encode("ascii","ignore").decode(); print(re.sub(r"[^a-z0-9]+","-",n.lower()).strip("-"))' "$f")
  case "$name" in
    00-*|lab-*) dest="../labs/n8n/${name}.json" ;;
    *)          dest="./workflows/${name}.json" ;;
  esac
  mv "$f" "$dest"
  echo "exporté : ${dest#../}"
done
