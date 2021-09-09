#!/bin/sh

#Make sure that we go into the correct directory
dirName="$1"
cd "$dirName" || exit

#Concatenates all of the secure files together and filters out failed password attempts. Then, it will extact the date, time, username, and IP address of each failed password attempt and then output it into the failed_login_data.txt file.
cat var/log/secure* | awk '/Failed password for/ {
  dateInfo=substr($0, 0, index($0, ":") - 1);
  if(index($0, "invalid user") > 0) {
    match($0, /invalid user ([^ ]+) from ([^ ]+)/, groups);
  }else {
    match($0, /Failed password for ([^ ]+) from ([^ ]+)/, groups);
  }
  username=groups[1];
  IP=groups[2];
  print dateInfo, username, IP;
}' > failed_login_data.txt
