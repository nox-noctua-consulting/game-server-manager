#!/bin/bash
source cli/shared.sh
source cli/peon.sh
source cli/game.sh

menu_main() {
    draw_menu_header $menu_size "$app_name" "M A I N - M E N U"
    printf " 1. List All Containers\n"
    printf " 2. Peon Application Containers\n"
    printf " 3. Game Containers\n"
    printf " 0. Exit\n\n"
}

menu_main_read_options() {
    local choice
    read -p "Enter selection: " choice
    case $choice in
    0)
        clear
        exit 0
        ;;
    1) list_all_containers ;;
    2) menu_peon ;;
    3) menu_game ;;
    *) printf "\n ${RED_HL}*Invalid Option*${STD}\n" && sleep 0.75 ;;
    esac
}

trap 'exit 0' SIGINT SIGQUIT SIGTSTP
while true; do

    if [ -z "$1" ]; then
        menu_main
        menu_main_read_options
    else
        case "$1" in
        -u | --update)
            peon_update_containers
            exit $?
            ;;
        -s | --start)
            peon_start_containers
            exit $?
            ;;
        -p | --stop)
            peon_stop_containers
            exit $?
            ;;
        -r | --restart)
            peon_restart_containers
            exit $?
            ;;
        -m | --metrics)
            docker stats
            exit $?
            ;;
        -k | --killall)
            printf "${RED}Stopping${STD} all containers\n"
            if [[ -z $(docker ps -q) ]]; then
                echo " Containers already stopped"
            else
                docker stop $(docker ps -q)
            fi
            exit $?
            ;;
        -* | --*=) # unsupported flags
            echo "ERROR: $1 is not supported." >&2
            printf " Supported flags are:\n"
            printf "\t-u|--update\t(U)pdates infrastrcture containers\n"
            printf "\t-s|--start\t(S)tarts infrastrcture conatiners\n"
            printf "\t-p|--stop\tSto(p)s infrastrcture containers\n"
            printf "\t-r|--restart\t(R)estarts infrastrcture containers\n"
            printf "\t-m|--metrics\tPerformance statistics/(M)etrics for ALL containers.\n"
            printf "\t-k|--kill\t(K)ill ALL running containers.\n"
            exit 1
            ;;
        esac
    fi
done
