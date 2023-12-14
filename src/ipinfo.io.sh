#!/bin/bash
IPINFP_TOKEN=$1

names=(
    asn.mmdb
    asn.json.gz
    asn.csv.gz
    country.mmdb
    country.json.gz
    country.csv.gz
    country_asn.mmdb
    country_asn.json.gz
    country_asn.csv.gz
)

mkdir -p ./checksums
dlnames=()
dlidx=0
for name in ${names[*]}; do
    checkfile="./checksums/${name}.json"
    oldmd5=
    oldsha1=
    oldsha256=
    if [ -f "$checkfile" ]; then
        oldchecksums=$(cat $checkfile)
        oldmd5=$(echo "$oldchecksums" | grep "md5" | cut -d '"' -f 4)
        # oldsha1=$(echo "$oldchecksums" | grep "sha1" | cut -d '"' -f 4)
        # oldsha256=$(echo "$oldchecksums" | grep "sha256" | cut -d '"' -f 4)
    fi

    checksums=$(curl "https://ipinfo.io/data/free/${name}/checksums?token=${IPINFP_TOKEN}")
    md5=$(echo "$checksums" | grep "md5" | cut -d '"' -f 4)

    if [ -z "$md5" ] || [ "$oldmd5" == "$md5" ]; then
        echo "the md5 hash value of ${name} is empty or equal to the original hash value ${oldmd5}" 1>&2
        continue
    fi

    # sha1=$(echo "$checksums" | grep "sha1" | cut -d '"' -f 4)
    # sha256=$(echo "$checksums" | grep "sha256" | cut -d '"' -f 4)

    echo "$checksums" >$checkfile
    dlnames[$dlidx]="$name"
    dlidx=$((${dlidx} + 1))
done

success=true
if [ ${#dlnames[*]} -eq 0 ]; then
    success=false
fi
echo "success=${success}"
