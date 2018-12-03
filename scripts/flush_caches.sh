#!/bin/sh

# Author: Lloyd Dilley
# Date: 10/17/2011
# Purpose: This script frees cached memory and attempts to move swap data into
#          physical memory.

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root!"
  exit 1
fi

if [ "$(uname -s)" != "Linux" ]; then 
  echo "This script only supports Linux!"
  exit 1
fi

while :; do
  echo -n "Warning: Memory caches will be dropped and swap will be" \
          "remounted. Proceed ([Y]es/[N]o)?: "
  read response
  response=$(echo "${response}" | tr '[:upper:]' '[:lower:]')
  case "${response}" in 
    y|yes ) break;;
    n|no ) exit 0;;
    * ) echo "Invalid response!";;
  esac
done

echo "Flushing caches and remounting swap..."
echo "Memory usage before:"
free -m
echo ""
sync
echo 3 > /proc/sys/vm/drop_caches
echo "Moving swap data to physical memory (this may take several minutes)..."
/sbin/swapoff -a
/sbin/swapon -a
echo ""
echo "Memory usage after:"
free -m
echo ""
