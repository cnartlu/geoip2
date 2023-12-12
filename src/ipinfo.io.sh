#!/bin/bash
IPINFP_TOKEN=$1

names=(asn.mmdb asn.json.gz asn.csv.gz country.mmdb country.json.gz country.csv.gz country_asn.mmdb country_asn.json.gz country_asn.csv.gz)

body=$(curl "https://api.github.com/repos/cnartlu/geoip2/releases/latest" | grep '"body"' | cut -d '"' -f 4)

newbody="ipinfo文件对应的hash"

dlnames=()
dlidx=0
for name in ${names[*]}; do
    checksums=$(curl "https://ipinfo.io/data/free/${name}/checksums?token=${IPINFP_TOKEN}")
    md5=$(echo "$checksums" | grep "md5" | cut -d '"' -f 4)
    sha1=$(echo "$checksums" | grep "sha1" | cut -d '"' -f 4)
    sha256=$(echo "$checksums" | grep "sha256" | cut -d '"' -f 4)
    newbody="${newbody}
name:${name} md5:${md5} sha1:${sha1} sha256:${sha256}"
    if [ -z "$md5" ]; then
        continue
    fi
    checkmd5=$(echo "$body" | grep "name:$name" | cut -d " " -f 2 | cut -d ":" -f 2)
    if [ "$checkmd5" == "$md5" ]; then
        echo "${name} hash equal ${md5}" &>2
        continue
    fi
    dlnames[$dlidx]="$name"
done

if [ ${#dlnames[*]} -lt 1 ]; then
    return 0
fi
echo "$newbody"
