# Maintenance du serveur

Ce document decrit une routine simple pour garder le serveur stable.

## Routine hebdomadaire (5 minutes)

1. Verifier que le conteneur est sain :
   ```bash
   docker compose ps
   ```
2. Lire les logs recents :
   ```bash
   docker compose logs --tail 200 mc-server
   ```
3. Verifier l'espace disque de la machine hote.
4. Faire un backup avec `./backup.sh`.

## Sauvegarde

Le script `backup.sh` :
- envoie `save-all flush` au serveur pour limiter le risque de donnees incoherentes
- archive le dossier `data/` dans `backups/`
- conserve les 14 dernieres sauvegardes (rotation simple)

Commande :

```bash
./backup.sh
```

## Restauration

1. Lister les sauvegardes :
   ```bash
   ls -1 backups
   ```
2. Restaurer :
   ```bash
   ./restore.sh backups/<nom-archive>.tar.gz
   ```

Le script arrete le conteneur avant restauration puis le relance.

## Mise a jour

### Image serveur

```bash
docker compose pull
docker compose up -d
```

### Plugins

1. Backup (`./backup.sh`)
2. Remplacer les `.jar` dans `data/plugins/`
3. Redemarrer :
   ```bash
   docker compose restart mc-server
   ```
4. Verifier les logs.

## Depannage rapide

- Java ne se connecte pas :
  - verifier `25565/tcp` mappe et redirige sur la box
  - verifier `docker compose ps`
- Bedrock ne se connecte pas :
  - verifier `19132/udp` mappe et redirige sur la box
  - verifier Geyser/Floodgate charges dans les logs
- Joueur refuse :
  - verifier whitelist (`whitelist list`) et pseudo exact

## Bonnes pratiques

- Garder `ENABLE_WHITELIST=TRUE`, `ENFORCE_WHITELIST=TRUE` et `ONLINE_MODE=true` dans `docker-compose.yml`
- Verifier aussi `white-list=true`, `enforce-whitelist=true` et `online-mode=true` dans `data/server.properties`
- Eviter d'editer `data/whitelist.json` pendant que le serveur tourne
- Mettre a jour de maniere incremental (une modif a la fois)
- Conserver plusieurs sauvegardes (local + disque externe si possible)
