#!/usr/bin/env bash
#############################################################
# Author:   Samuel BOISTEL
# Purpose:  Borg Backup Script
# Date:     Fev 2024
#############################################################

# Variables
BorgRepo="$1"
TargetDir="$2"

# Functions
_help () {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -c, --check     Check if the repository is initialized"
    echo "  -b, --backup    Backup the docker volumes"
    echo "  -p, --prune     Prune the repository"
    echo "  -i, --info      Display the backup information"
    echo "  -l, --list      List the archives in the repository"
}

_checkinit () {
    echo "Check if $BorgRepo is initialized"
    if ! borg info $BorgRepo > /dev/null 2>&1; then
        echo "Initialize $BorgRepo"
        borg init -e none $BorgRepo
    fi
}

_docker_backup () {
    borg create  \
    --stats --progress \
    -C zstd,10  \
    $BorgRepo::docker_$dime /opt/docker
}

_prune () {
    retention=6
    if [ "$(borg list $BorgRepo | wc -l)" -gt $retention ]; then
        echo "Prune archives in $BorgRepo"
        borg prune --keep-last $retention $BorgRepo
    fi
}

_info () {
	for backup in $(borg list $BorgRepo | grep ${dime} | awk '{print $1}')
	do
    		borg info ${BorgRepo}::$backup >> $logfile
	done
	echo "###" >> $logfile
	echo $logfile
}

_list () {
    echo "List archives in $BorgRepo"
    borg list $BorgRepo
}

# Run

if [ -z "$1" ]; then
    _help
    exit 1
else
    case "$1" in
        -c|--check)
            _checkinit
            ;;
        -b|--backup)
            _checkinit
            _docker_backup
            _prune
            _info
            ;;
        -p|--prune)
            _prune
            ;;
        -i|--info)
            _info
            ;;
        -l|--list)
            _list
            ;;
        *)
            _help
            exit 1
            ;;
    esac
fi
# END
