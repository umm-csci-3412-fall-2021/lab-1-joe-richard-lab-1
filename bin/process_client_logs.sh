#!/usr/bin/env bash

# The command-line argument should be a directory containing all of the logs
# for a particular machine. Go there.
dirName="$1"
cd "$dirName" || exit 1

# Concatenate all of the secure files together, and use AWK to select just the
# failed password attempts. Then, extact the date, time, username, and IP
# address of each failed password attempt, and output them to the
# `failed_login_data.txt` file.
cat var/log/secure* | awk '/Failed password for/ {
  # Get the line up until the first colon character. (This gets the month, day,
  # and hour of the failed login attempt.
  dateInfo=substr($0, 0, index($0, ":") - 1);

  # Next, get the username they tried to log in as, and the source IP address.
  # (This information is in one of two formats, depending on whether the
  # username exists on the system or not.)
  if(index($0, "invalid user") > 0) {
    match($0, /Failed password for invalid user ([^ ]+) from ([^ ]+)/, groups);
  } else {
    match($0, /Failed password for ([^ ]+) from ([^ ]+)/, groups);
  }
  username=groups[1];
  IP=groups[2];

  print dateInfo, username, IP;
}' | tr -s " " > failed_login_data.txt

# The tr command will replace all duplicate spaces with a singular space.
# (The log file uses spaces to align the date and make it look nice. We'd
# rather have single-spaced output, since that's easier to unit-test.)
