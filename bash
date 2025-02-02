#!/usr/bin/env bash
#
# TODO(self): document script

# TODO(self): complete function
function get_content_1() {
    printf '%s\n' apple apple orange
}

# TODO(self): complete function
function get_content_2() {
    printf '%s\n' apple applefuji orange
}

function get_unique_lines() {
    sort "$1" | uniq
}

# loop over stdin one line at a time. for each line read, determine the number of 
# matching lines in files $1 and $2.
function count_matches() {
    local -r SOURCE_FILE="$1"
    local -r TARGET_FILE="$2"
    local -i code=0

    # TODO(self): adapt to naming to task
    echo "line source target"

    while read -r line; do
        n="$( grep --fixed-strings --line-regexp --count "$line" "$SOURCE_FILE" )"
        m="$( grep --fixed-strings --line-regexp --count "$line" "$TARGET_FILE" )"
        (( n == m )) && match='ok' || match='failed' code=1
        echo "$line $n $m $match"
    done

    (( code == 0 )) && touch "$ok"
}

function main() {
    tmp="$( command mktemp -d )" && trap "rm -r '$tmp'" EXIT

    # control file to signal script OK
    ok="$tmp/ok.ctl"

    # temporary files for intermediate computations
    # TODO(self): rename content_1, content_2
    content_1="$tmp/content_1.txt"
    content_2="$tmp/content_2.txt"

    get_content_1 > "$content_1"
    get_content_2 > "$content_2" 

    get_unique_lines "$content_1" | count_matches "$content_1" "$content_2" | column -t

    [[ -f "$ok" ]] && exit 0 || exit 1
}

main "$@"
