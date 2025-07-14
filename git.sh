#!/usr/bin/env bash

source ~/.local/bin/fancy_echo.sh

# Global Config
ASCII_LOCK="$HOME/.cache/ascii_lock"
ATOMIC_LOCK="$HOME/.cache/atomic_lock"
ATOMIC_CEIL="$HOME/.cache/atomic_ceil"

if [[ "$1" == "--ascii-lock" ]]; then
    if [[ "$2" == "on" ]]; then
        echo "1" > "$ASCII_LOCK"
        echo "Non-ASCII hook is on!"
    elif [[ "$2" == "off" ]]; then
        echo "0" > "$ASCII_LOCK"
        echo "Non-ASCII hook is off!"
    else
        echo -e "${BOLD_Y}INVALID ARG!${RESET} The second arg can only be on/off."
        exit 1
    fi
    exit 0
fi

if [[ "$1" == "--atomic-lock" ]]; then
    if [[ "$2" == "on" ]]; then
        echo "1" > "$ATOMIC_LOCK"
        echo "Atomic commit hook is on!"
    elif [[ "$2" == "off" ]]; then
        echo "0" > "$ATOMIC_LOCK"
        echo "Atomic commit hook is off!"
    else
        echo -e "${BOLD_Y}INVALID ARG!${RESET} The second arg can only be on/off!"
        exit 1
    fi
    exit 0
fi

if [[ "$1" == "--atomic-ceil" ]]; then
    if [[ "$2" =~ ^[0-9]+$ && "$2" -gt 0 ]]; then
        echo "$2" > "$ATOMIC_CEIL"
        echo -e "Atomic ceil is set to be $2!"
    else
        echo -e "${BOLD_Y}INVALID ARG!${RESET} The second arg must be a positive integer!"
        exit 1
    fi
    exit 0
fi

fecho -BIp "Regular Git Commit..."

if ! git pull; then
    exit 1
fi

if [ $# -eq 0 ]; then
    if ! git add .; then
        exit 1
    fi
else
    for file in "$@"; do
        if ! git add "$file"; then
            exit 1
        fi
    done
fi

# Non-ASCII Hook
ascii_lock=$(cat "$ASCII_LOCK")
if [ "$ascii_lock" -eq 1 ]; then
    has_non_ascii=0
    fecho -BIp "Non-ASCII Hook:"

    cd "$(git rev-parse --show-toplevel)"
    for file in $(git diff --cached --name-only --diff-filter=ACM -- "$@"); do
        if [ -f "$file" ]; then
            matches=$(LC_ALL=C grep -n '[^[:print:][:space:]]' "$file")
            if [ -n "$matches" ]; then
                echo -e "${BOLD_Y}NON-ASCII CHARACTERS FOUND IN${RESET} $file:"
                echo "$matches" | while IFS= read -r line; do
                echo "    $file:${line}"
            done
            has_non_ascii=1
            fi
        fi
    done

    if [ "$has_non_ascii" -eq 1 ]; then
        fecho -By "COMMIT ABORTED DUE TO NON-ASCII CHARACTERS!"
        exit 1
    else
        echo "No non-ASCII characters detected."
    fi
fi

# Atomic Commit Hook
added=0
deleted=0
while IFS=$'\t' read -r add del file; do
    [[ "$add" == "-" || "$del" == "-" ]] && continue
    added=$((added + add))
    deleted=$((deleted + del))
done < <(git diff --cached --numstat -- "$@")
total=$((added + deleted))

fecho -BIp "Atomic Commit Hook:"
echo -e "${BOLD_C}$added ++${RESET}  ${BOLD_R}$deleted --${RESET}"

atomic_lock=$(cat "$ATOMIC_LOCK")
if [ "$atomic_lock" -eq 1 ]; then
    if [ -f "$ATOMIC_CEIL" ]; then
        atomic_ceil=$(cat "$ATOMIC_CEIL")
    else
        atomic_ceil=70
    fi

    if [ "$added" -gt "$atomic_ceil" ]; then
        echo -e "${BOLD_Y}YOU TRY TO COMMIT MORE THAN $atomic_ceil LINES!${RESET} Do you want to continue with non-atomic commit? If so, enter Y/y."
        read is_non_atomic
        tput cuu 1
        tput el
        tput cuu 1
        tput el
        if [[ "$is_non_atomic" =~ ^[Yy]$ ]]; then
            fecho -By "Non-atomic Commit: Continue!"
        else
            fecho -By "Non-atomic Commit: Quit!"
            exit 1
        fi
    fi
fi

# Type
has_fail=false
while true; do
    echo -e "${BOLD_ITALIC}Type${RESET}:
    f -- ${BOLD_P}feat${RESET}: A new feature.
    x -- ${BOLD_P}fix${RESET}: A bug fix.
    t -- ${BOLD_P}test${RESET}: Adding or modifying tests.
    d -- ${BOLD_P}docs${RESET}: Documentation changes.
    s -- ${BOLD_P}style${RESET}: Code style changes.
    r -- ${BOLD_P}refactor${RESET}: Code refactoring.
    p -- ${BOLD_P}perf${RESET}: Improving performance.
    b -- ${BOLD_P}build${RESET}: Affecting the build system.
    c -- ${BOLD_P}chore${RESET}: Maintenance or tooling changes.
    v -- ${BOLD_P}revert${RESET}: Roll back to a previous commit."
    read type
    if [[ "$type" =~ ^[fxtdsrpbcv]$ ]]; then
        break
    else
        for ((i=0; i<12; i++)); do
            tput cuu 1
            tput el
        done
        if $has_fail; then
            tput cuu 1
            tput el
        fi
        fecho -By "INVALID TYPE! CHOOSE AGAIN!"
        has_fail=true
    fi
done
for ((i=0; i<12; i++)); do
    tput cuu 1
    tput el
done
if $has_fail; then
    tput cuu 1
    tput el
fi
case "$type" in
    f)  Type="feat";;
    x)  Type="fix";;
    t)  Type="test";;
    d)  Type="docs";;
    s)  Type="style";;
    r)  Type="refactor";;
    p)  Type="perf";;
    b)  Type="build";;
    c)  Type="chore";;
    v)  Type="revert";;
esac
echo -e "${BOLD_ITALIC}Type${RESET}: ${BOLD_P}$Type${RESET}"

# Scope (Optional)
echo -e "${BOLD_ITALIC}Scope${RESET}:"
read scope
tput cuu 1
tput el
tput cuu 1
tput el
if [[ -z "$scope" ]]; then
    scope="/"
fi
echo -e "${BOLD_ITALIC}Scope${RESET}: $scope"

# Description
has_fail=false
while true; do
    echo -e "${BOLD_ITALIC}Description${RESET}:"
    read description
    if [[ -z "$description" ]]; then
        for ((i=0; i<2; i++)); do
            tput cuu 1
            tput el
        done
        if $has_fail; then
            tput cuu 1
            tput el
        fi
        fecho -By "YOU MUST WRITE SOMETHING!"
        has_fail=true
    else
        break
    fi
done
tput cuu 1
tput el
tput cuu 1
tput el
if $has_fail; then
    tput cuu 1
    tput el
fi
echo -e "${BOLD_ITALIC}Description${RESET}: $description"

# Body (Optional)
echo -e "${BOLD_ITALIC}Body${RESET}:"
read body
tput cuu 1
tput el
tput cuu 1
tput el
if [[ -z "$body" ]]; then
    body="/"
fi
echo -e "${BOLD_ITALIC}Body${RESET}: $body"

# Footer (Optional)
echo -e "${BOLD_ITALIC}Footer${RESET}:
    > Is this a ${BOLD_Y}BREAKING CHANGE${RESET}? If so, enter details."
read breaking_change
tput cuu 1
tput el
tput cuu 1
tput el
if [[ -z "$breaking_change" ]]; then
    breaking_change="/"
fi
echo -e "   > ${BOLD_Y}BREAKING CHANGE${RESET}: $breaking_change"
echo -e "   > Does this ${BOLD_Y}close an issue${RESET}? If so, enter the number."
read issue_num
tput cuu 1
tput el
tput cuu 1
tput el
if [[ -z "$issue_num" ]]; then
    close_issue="/"
else
    close_issue="#$issue_num"
fi
echo -e "   > ${BOLD_Y}Closes Issue${RESET}: $close_issue"

# Output
if [[ "$scope" == "/" ]]; then
    Scope=""
else
    Scope="($scope)"
fi
if [[ "$body" == "/" ]]; then
    Body=""
else
    Body="\n\n$body"
fi
if [[ "$breaking_change" == "/" ]]; then
    Breaking_change=""
    breaking_change_note=""
else
    Breaking_change="\n\nBREAKING CHANGE: $breaking_change"
    breaking_change_note="!"
fi
if [[ "$close_issue" == "/" ]]; then
    Close_issue=""
else
    if [[ "$breaking_change" == "/" ]]; then
        Close_issue="\n\nCloses $close_issue"
    else
        Close_issue="\nCloses $close_issue"
    fi
fi
msg="$Type$Scope$breaking_change_note: $description$Body$Breaking_change$Close_issue"
echo -e "\n${BOLD_ITALIC_P}Conventional Commit Message:${RESET}\n$msg\n"

files_to_commit=("$@")
echo -e "$msg" | git commit -F - -- "${files_to_commit[@]}" 2>&1
commit_status=$?
if [ $commit_status -ne 0 ]; then
    exit 1
fi

if ! git push; then
    exit 1
fi


