#!/usr/bin/env bash

# The path to a directory containing a bunch of subfolders--one for each
# machine--each subfolder containing a `failed_login_data.txt` file.
logsDir="$1"

tmpFile="$(mktemp /tmp/tmp.XXXXXXXXXXX)"

# Note that \x27 is the ' character.
# Note that the join command matches IP addresses with their country-codes:
# `-o 2.2` says that just the country-code should be printed.
cat "$logsDir"/*/failed_login_data.txt \
  | awk '{ print $5 }' \
  | sort \
  | join - etc/country_IP_map.txt -o 2.2 \
  | sort \
  | uniq --count \
  | awk '{ printf("data.addRow([\x27%s\x27, %d]);\n", $2, $1) }' \
  > "$tmpFile"

# Takes the data in the temp file and adds the correct header and footer,
# saving the result into the logsDir directory.
./bin/wrap_contents.sh \
  "$tmpFile" \
  html_components/country_dist \
  "$logsDir"/country_dist.html

rm "$tmpFile"
