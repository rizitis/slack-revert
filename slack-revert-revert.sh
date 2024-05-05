#!/bin/bash

# Anagnostakis Ioannis (aka rizitis) 2024 April
# This script called from main slack-revert script if user want to revert system 
# Better here than all in one...

# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package="$snap1"
mirror_url=$URL
PACKDIR=$DIR/packages
rm -rf "$PACKDIR"


RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RESET='\033[0m'
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Error: This script must be run as root :*${RESET}"
  exit 
fi


# URL for FILELIST.TXT
file_list_url="${mirror_url}FILELIST.TXT"

# Create or clean FILELIST.TXT
tmp_dir=$DIR
> "${tmp_dir}/FILELIST.TXT"

# Download FILELIST.TXT
wget -O "${tmp_dir}/FILELIST.TXT" "$file_list_url" || {
  echo -e "${RED}Error: Could not download FILE_LIST from $file_list_url.${RESET}"
  exit 1
}

sed -i '/\.\(txz\|tgz\)$/!d' "${tmp_dir}/FILELIST.TXT"
wait
sed -i 's/^.*\(\.\/\)/\1/' "${tmp_dir}/FILELIST.TXT"
wait
sed -i '/^$/d' "${tmp_dir}/FILELIST.TXT"
wait
sed -i 's/^..//' "${tmp_dir}/FILELIST.TXT"
wait

mkdir -p "$PACKDIR" || exit 33
cd $PACKDIR || exit 33

# clean or create...
> finaly-url.txt
> errors.txt

# Load patterns from local snap file into an array
patterns=()
while IFS= read -r line; do
    patterns+=("$line")
done < "$DIR"/2/"$package"


# search for patterns in FILELIST.TXT
awk -v patterns="${patterns[*]}" '
BEGIN {
    # Convert patterns into an array
    split(patterns, pattern_array, " ")
}
{
    # Loop through the pattern array
    for (i in pattern_array) {
        # If the current line contains a pattern, print it
        if ($0 ~ pattern_array[i]) {
            print $0
            break
        }
    }
}
' "${tmp_dir}/FILELIST.TXT" >> finaly-url.txt
wait


# Read each line from 'finaly-url.txt' and download packages.
while IFS= read -r suburl; do
    wget -c "$URL""$suburl" || {
        echo "Error downloading $suburl" >> errors.txt
    } &
done < finaly-url.txt
wait
clear

if [[ -s errors.txt ]]; then
    # If errors.txt is not empty, print an error message in red
    echo -e "${RED}Errors were found. Some packages didn't download:${RESET}"
    echo "-----------------------------------------"
    cat errors.txt
else
    echo -e "${GREEN}No errors found.${RESET}"
fi

while true; do
    read -p "Do you want to proceed with the installation? (y/n): " response

    case "$response" in
        y|Y|yes|YES)
            echo -e "${BLUE}Proceeding with installation...${RESET}"
            upgradepkg --install-new --reinstall *.t?z
            wait
echo ""
echo -e "${RED}Reminder:${RESET}"
echo -e "${GREEN}  - Don't forget to create initrd if needed.${RESET}"
echo -e "${GREEN}  - Don't forget to update the bootloader.${RESET}"
echo ""
            break  
            ;;
        n|N|no|NO)
            echo -e "${RED}Installation aborted.${RESET}"
            exit 0  
            ;;
        *)
            echo -e "${RED}Invalid response. Please enter 'y' or 'n'.${RESET}"
            ;;
    esac
done

