#!/bin/bash

DATA_DIR_PATH=../data
DB_FILE_NAME=user.db
DB_FILE_PATH=$DATA_DIR_PATH/$DB_FILE_NAME
BACKUP_DIR_NAME=backup
BACKUP_DIR_PATH=$DATA_DIR_PATH/$BACKUP_DIR_NAME
BACKUP_FILE_BASE_NAME=user.db.backup

RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

function help() {
    echo "add instructions"
    echo "backup instructions"
    echo "find instructions"
    echo "restore instructions"
    echo "list instructions"
    echo "help instructions"
}

function add() {
    printf "Enter${BLUE} username${NC}\n"
    read USERNAME
    printf "Enter${BLUE} role${NC}\n"
    read ROLE

    if [[ "$USERNAME" =~ ^[a-zA-Z] ]] && [[ "$ROLE" =~ ^[a-zA-Z] ]]; then

        if test ! -f "$DB_FILE_PATH"; then
            read -p "Do you want to create user.db file? (y/n) " yn

            case $yn in
            yes) touch $DB_FILE_PATH ;;
            no)
                printf "${RED}exiting...${NC}\n"
                exit
                ;;
            *)
                printf "${RED}Error: invalid response${NC}\n"
                exit 1
                ;;
            esac

        fi

        echo $USERNAME, $ROLE >>$DB_FILE_PATH

    else
        printf "${RED}Error: username or role is not valid${NC}\n"
    fi

}

function backup() {
    CURRENT_DATE=$(date '+%Y-%m-%d')
    BACKUP_PATH=$BACKUP_DIR_PATH/$CURRENT_DATE-$BACKUP_FILE_BASE_NAME

    cp $DB_FILE_PATH $BACKUP_PATH
}

function restrore() {
    unset -v latest

    for file in $BACKUP_DIR_PATH/*; do
        [[ $file -nt $latest ]] && latest=$file
    done

    if [ ! -z "$latest" ]; then
        cat $latest >$DB_FILE_PATH
    else
        printf "${RED}Error: No backup file found${NC}\n"
    fi
}

function find() {
    printf "Enter${BLUE} username${NC}\n"
    read USERNAME

    RESULT="$(grep -R "$USERNAME" $DB_FILE_PATH)"

    if [ ! -z "$RESULT" ]; then
        echo $RESULT
    else
        printf "${CYAN}User not found${NC}\n"
    fi
}

function list() {
    if [ -z $1 ]; then
        nl $DB_FILE_PATH
    else
        nl $DB_FILE_PATH | sort -nr
    fi
}

function main() {
    case $1 in

    add)
        add
        ;;

    backup)
        backup
        ;;

    find)
        find
        ;;

    restore)
        restrore
        ;;

    list)
        list $2
        ;;

    help)
        help
        ;;
    esac
}

main $1 "$2"
