#!/usr/bin/bash

if [ -z $1 ]; then
    echo "缺失访问令牌"
    exit 1
fi

arr=( asn.mmdb asn.json.gz asn.csv.gz country.mmdb country.json.gz country.csv.gz country_asn.mmdb country_asn.json.gz country_asn.csv.gz )
for v in ${arr[*]}
do
 wget https://ipinfo.io/data/free/${v}?token=${1} -o ./${v}
done
