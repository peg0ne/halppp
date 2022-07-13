#!/usr/bin/bash
get_info_in() {
    NROFFILE=$(find $1 -type f | grep $3 | wc -l)
    NROFLINE=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -l)
    NROFWORDS=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -w)
    NROFCHARS=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -m)
    MAXLINELEN=$(find $1 -type f | grep $3 | xargs cat | grep -v -e "^$" | wc -L)
    echo ""
    echo $2":"
    echo "Files:" $NROFFILE
    echo "Lines of code:" $NROFLINE
    echo "Total words:" $NROFWORDS
    echo "Total chars:" $NROFCHARS
    echo "Max Line len: " $MAXLINELEN
    echo ""
}

get_info_in "src" "Rust Compiler" "\.rs"
get_info_in "tests/compiler" "Self Compiler" "\.h"