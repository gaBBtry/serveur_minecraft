# Serveur Minecraft (Java + Bedrock)

Petit serveur Minecraft familial base sur Docker Compose.

Le serveur utilise :
- `Paper` (Java Edition)
- `Geyser` + `Floodgate` (pour autoriser les joueurs Bedrock)
- une persistance des donnees dans `./data`

## Prerequis

- Docker
- Docker Compose v2
- Ports rediriges sur la box vers la machine hote :
  - `25565/tcp` (Java)
  - `19132/udp` (Bedrock)

## Structure du projet

- `docker-compose.yml` : definition du conteneur Minecraft
- `data/` : donnees persistantes du serveur (mondes, plugins, config, whitelist)
- `backup.sh` : script de sauvegarde du dossier `data/`
- `restore.sh` : script de restauration d'une sauvegarde
- `MAINTENANCE.md` : guide de maintenance courant

## Commandes utiles

Demarrer le serveur :

```bash
docker compose up -d
```

Arreter le serveur :

```bash
docker compose down
```

Redemarrer uniquement le serveur Minecraft :

```bash
docker compose restart mc-server
```

Voir l'etat :

```bash
docker compose ps
```

Suivre les logs :

```bash
docker compose logs -f mc-server
```

## Whitelist

Le serveur est configure pour utiliser une whitelist.

Verification principale dans `docker-compose.yml` :
- `ENABLE_WHITELIST=TRUE`
- `ENFORCE_WHITELIST=TRUE`
- `ONLINE_MODE=true`

Verification complementaire dans `data/server.properties` :
- `white-list=true`
- `enforce-whitelist=true`
- `online-mode=true`

Exemples de commandes (depuis la console serveur) :
- `whitelist on`
- `whitelist add <Pseudo>`
- `whitelist remove <Pseudo>`
- `whitelist list`

## Bedrock (Geyser/Floodgate)

Pour autoriser les joueurs Bedrock :
- installer `Geyser-Spigot` et `floodgate-spigot` dans `data/plugins`
- garder le mapping de port UDP `19132:19132/udp`

Verification rapide dans les logs :
- `Started Geyser on UDP port 19132`

## Sauvegardes

Backup rapide :

```bash
./backup.sh
```

Restauration :

```bash
./restore.sh backups/<nom-archive>.tar.gz
```

Details et routine : voir `MAINTENANCE.md`.
