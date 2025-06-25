#!/bin/bash

R="\033[38;2;194;85;73m"
C="\033[38;2;77;185;133m"
Y="\033[38;2;210;165;44m"
B="\033[38;2;71;108;197m"
V="\033[38;2;126;73;194m"
P="\033[38;2;222;106;169m"

BOLD_R="\033[1;38;2;194;85;73m"
BOLD_C="\033[1;38;2;77;185;133m"
BOLD_Y="\033[1;38;2;210;165;44m"
BOLD_B="\033[1;38;2;71;108;197m"
BOLD_V="\033[1;38;2;126;73;194m"
BOLD_P="\033[1;38;2;222;106;169m"

ITALIC_R="\033[3;38;2;194;85;73m"
ITALIC_C="\033[3;38;2;77;185;133m"
ITALIC_Y="\033[3;38;2;210;165;44m"
ITALIC_B="\033[3;38;2;71;108;197m"
ITALIC_V="\033[3;38;2;126;73;194m"
ITALIC_P="\033[3;38;2;222;106;169m"

BOLD_ITALIC_R="\033[1;3;38;2;194;85;73m"
BOLD_ITALIC_C="\033[1;3;38;2;77;185;133m"
BOLD_ITALIC_Y="\033[1;3;38;2;210;165;44m"
BOLD_ITALIC_B="\033[1;3;38;2;71;108;197m"
BOLD_ITALIC_V="\033[1;3;38;2;126;73;194m"
BOLD_ITALIC_P="\033[1;3;38;2;222;106;169m"

BOLD="\033[1m"
ITALIC="\033[3m"
BOLD_ITALIC="\033[1;3m"

RESET="\033[0m"

fecho() {
    local style="$1"
    shift
    local message="$*"

    case "$style" in
        -r)     echo -e "${R}$message${RESET}" ;;
        -c)     echo -e "${C}$message${RESET}" ;;
        -y)     echo -e "${Y}$message${RESET}" ;;
        -b)     echo -e "${B}$message${RESET}" ;;
        -v)     echo -e "${V}$message${RESET}" ;;
        -p)     echo -e "${P}$message${RESET}" ;;
        -Br)    echo -e "${BOLD_R}$message${RESET}" ;;
        -Bc)    echo -e "${BOLD_C}$message${RESET}" ;;
        -By)    echo -e "${BOLD_Y}$message${RESET}" ;;
        -Bb)    echo -e "${BOLD_B}$message${RESET}" ;;
        -Bv)    echo -e "${BOLD_V}$message${RESET}" ;;
        -Bp)    echo -e "${BOLD_P}$message${RESET}" ;;
        -Ir)    echo -e "${ITALIC_R}$message${RESET}" ;;
        -Ic)    echo -e "${ITALIC_C}$message${RESET}" ;;
        -Iy)    echo -e "${ITALIC_Y}$message${RESET}" ;;
        -Ib)    echo -e "${ITALIC_B}$message${RESET}" ;;
        -Iv)    echo -e "${ITALIC_V}$message${RESET}" ;;
        -Ip)    echo -e "${ITALIC_P}$message${RESET}" ;;
        -BIr)   echo -e "${BOLD_ITALIC_R}$message${RESET}" ;;
        -BIc)   echo -e "${BOLD_ITALIC_C}$message${RESET}" ;;
        -BIy)   echo -e "${BOLD_ITALIC_Y}$message${RESET}" ;;
        -BIb)   echo -e "${BOLD_ITALIC_B}$message${RESET}" ;;
        -BIv)   echo -e "${BOLD_ITALIC_V}$message${RESET}" ;;
        -BIp)   echo -e "${BOLD_ITALIC_P}$message${RESET}" ;;
        -B)     echo -e "${BOLD}$message${RESET}" ;;
        -I)     echo -e "${ITALIC}$message${RESET}" ;;
        -BI)    echo -e "${BOLD_ITALIC}$message${RESET}" ;;
        -B-)    echo -e "${BOLD}$message" ;;
        -I/)    echo -e "${ITALIC}$message" ;;
        -BI/)   echo -e "${BOLD_ITALIC}$message" ;;
        -)      echo -e "${RESET}" ;;
        *)      echo -e "$message" ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    export -f fecho
else
    fecho "$@"
fi
