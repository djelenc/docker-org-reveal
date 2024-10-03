#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file1.org> <file2.org> ... or $0 *.org"
    exit 1
fi

cp -r /reveal.js . # copy reveal.js to CWD

for file in "$@"; do
    if [ -f "$file" ]; then
        emacs \
            --no-init-file \
            --user="" \
            --batch \
            --eval="(require 'org)" \
            --eval="(require 'ox-reveal)" \
            --find-file="${file}" \
            --funcall="org-reveal-export-to-html"
    else
        echo "File not found: $file"
    fi
done
