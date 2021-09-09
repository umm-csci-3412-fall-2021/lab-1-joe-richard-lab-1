#!/bin/sh

#Adding helpful variable names to the given arguments
fileName="$1"
specifier="$2"
resultFile="$3"

#Creating more variable names by using the previously given arguments
HEADER="$specifier"_header.html
FOOTER="$specifier"_footer.html

#Concatenating the three files together into the resultFile
cat "$HEADER" "$fileName" "$FOOTER" > "$resultFile"
