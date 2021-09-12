#!/usr/bin/env bash

# The path to a directory containing a bunch of subfolders--one for each
# machine--each subfolder containing a `failed_login_data.txt` file.
logsDir="$1"

tmpFile="$(mktemp /tmp/tmp.XXXXXXXXXXX)"

cat "$logsDir"/*/failed_login_data.txt \
  | awk '{ print $4 }' \
  | sort \
  | uniq --count \
  #Note that \x27 is the ' character
  | awk '{ printf("data.addRow([\x27%s\x27, %d]);\n", $2, $1) }' \
  > "$tmpFile"

#Takes the data in the temp file and adds the correct header and footer,
#saving the result into data/username_dist.html
./bin/wrap_contents.sh "$tmpFile" html_components/username_dist data/username_dist.html

rm "$tmpFile"
