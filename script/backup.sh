#!/usr/bin/env bash
#############################################################
# Author:	Samuel BOISTEL
# Purpose:	Borg Backup Script
# Date:	    Fev 2024
#############################################################
set -o errexit
# Variables
BorgRepo="$1"
TargetDir="$2"

# Functions
_checkinit () {
    echo "Check if $BorgRepo is initialized"
    if ! borg info $BorgRepo > /dev/null 2>&1; then
        echo "Initialize $BorgRepo"
        borg init -e none $BorgRepo
    fi
}

_backup () {
    echo "Create a new archive of $TargetDir in $BorgRepo as $(date +%Y%m%d)"
    borg create  \
    --stats --progress \
    -C zstd,10  \
    --exclude "$TargetDir/.cache/*" \
    --exclude "$TargetDir/Nextcloud" \
    $BorgRepo::$(date +%Y%m%d)-4 $TargetDir
}

_prune () {
    if [ "$(borg list $BorgRepo | wc -l)" -gt 5 ]; then
        echo "Prune archives in $BorgRepo"
        borg prune --keep-last 5 $BorgRepo
    fi
}

# Run

if [ "$BorgRepo" = "auto" ]; then
    BorgRepo="/media/20104162/Backup/X504292/"
    TargetDir="/home/20104162/"
    _checkinit
    _backup
    _prune
elif [ -z "$BorgRepo" ] || [ -z "$TargetDir" ]; then
    echo "Usage: $0 <BorgRepo> <TargetDir>"
    echo "sh BorgBackup.sh /media/toto/Backup/tulipe /home/toto"
    echo "Flemard:"
    echo "sh BorgBackup.sh auto"
    exit 1
else
    _checkinit
    _backup
    _prune
fi

# END
