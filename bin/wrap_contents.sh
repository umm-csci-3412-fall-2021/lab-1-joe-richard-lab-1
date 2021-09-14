#!/usr/bin/env bash

# Adding helpful variable names to the given arguments
fileName="$1"
specifier="$2"
resultFile="$3"

# Creating more variable names by using the previously given arguments
header="$specifier"_header.html
footer="$specifier"_footer.html

# Concatenating the three files together into the resultFile
cat "$header" "$fileName" "$footer" > "$resultFile"
