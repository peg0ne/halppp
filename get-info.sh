#!/usr/bin/bash
FILES=0
LINES=0
WORDS=0
CHARS=0
SYMBOLS=0
LINELEN=0
get_info_in() {
    NROFFILE=$(find $1 -type f | grep $3 | wc -l)
    NROFLINE=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -l)
    NROFWORDS=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -w)
    NROFCHARS=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | tr -d ' ' | wc -m)
    NROFNONALPHA=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | tr -d ' ' | tr -d '[:alpha:]' | wc -m)
    MAXLINELEN=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -L)
    echo ""
    echo $2":"
    echo "Files:" $NROFFILE
    echo "Lines of code:" $NROFLINE
    echo "Total words:" $NROFWORDS
    echo "Total chars:" $NROFCHARS
    echo "Total non alpha chars:" $NROFNONALPHA
    echo "Max Line len: " $MAXLINELEN
    echo ""
    if [ $4 == "rust" ]; then
        FILES=$NROFFILE
        LINES=$NROFLINE
        WORDS=$NROFWORDS
        CHARS=$NROFCHARS
        SYMBOLS=$NROFNONALPHA
        LINELEN=$MAXLINELEN
    else
        FILES=$((FILES - NROFFILE))
        LINES=$((LINES - NROFLINE))
        WORDS=$((WORDS - NROFWORDS))
        CHARS=$((CHARS - NROFCHARS))
        SYMBOLS=$((SYMBOLS - NROFNONALPHA))
        LINELEN=$((LINELEN - MAXLINELEN))
    fi
}

get_info_in "src" "Rust Compiler" "\.rs" "rust"
get_info_in "compiler" "Self Compiler" "\.h" "self"
echo "Diff:"
echo Files: $((FILES * - 1))
if (( LINES > 0 )); then
    echo -e "\033[31mLines:" $((LINES * - 1))"\033[0m"
else
    echo -e "\033[33mLines:" $((LINES * - 1))"\033[0m"
fi
if (( WORDS > 0 )); then
    echo -e "\033[31mWords:" $((WORDS * - 1))"\033[0m"
else
    echo -e "\033[33mWords:" $((WORDS * - 1))"\033[0m"
fi
if (( $CHARS > 0 )); then
    echo -e "\033[31mChars:" $((CHARS * - 1))"\033[0m"
else
    echo -e "\033[33mChars:" $((CHARS * - 1))"\033[0m"
fi
if (( SYMBOLS > 0 )); then
    echo -e "\033[31mSymbols:" $((SYMBOLS * - 1))"\033[0m"
else
    echo -e "\033[33mSymbols:" $((SYMBOLS * - 1))"\033[0m"
fi
if (( LINELEN > 0 )); then
    echo -e "\033[31mMax Line Length:" $((LINELEN * - 1))"\033[0m"
else
    echo -e "\033[33mMax Line Length:" $((LINELEN * - 1))"\033[0m"
fi
