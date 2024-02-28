---
title: "Borg Backup"
description: "Borg is a deduplicating backup program"
tags: ["backup", "borg", "deduplication", "linux"]
---

## Installation

### Linux

Depending on your operating system, you can install Borg Backup :

### Red Hat/CentOS

```bash
sudo yum install borgbackup
```

#### Ubuntu/Debian

```bash
sudo apt-get install borgbackup
```

#### ASDF

```bash
asdf plugin-add borgbackup
```

...

## Usage

### Create a backup

```bash
borg create /path/to/repo::backup-name /path/to/directory
```

Using remote repository:

```bash
borg create user@remote:/path/to/repo::backup-name /path/to/directory
```

### List backups

```bash
borg list /path/to/repo
```

### Extract backup

```bash
borg extract /path/to/repo::backup-name
```

### Encryption

```bash
borg create --encryption=repokey /path/to/repo::backup-name /path/to/directory
```

## Script example

- [Borg Backup Script](script/backup.sh)

## Links

- [Borg Backup](https://borgbackup.readthedocs.io/en/stable/)
