#!/usr/bin/env bash

tempFile="$(mktemp /tmp/"tmpXXXX.txt")"
dirName="$1"

cat "$dirName"/country_dist.html "$dirName"/hours_dist.html "$dirName"/username_dist.html > "$tempFile"
./bin/wrap_contents.sh "$tempFile" html_components/summary_plots "$dirName"/failed_login_summary.html

rm "$tempFile"
