#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

fastly_raw_ips=( $(curl https://api.fastly.com/public-ip-list 2>/dev/null | jq -r ".addresses[]") )

fastly_ips_snippet=""

for ip in "${fastly_raw_ips[@]}"
do
   #fastly_ips_snippet="${fastly_ips_snippet}""\\\"${ip}\\\"""; # Fastly cache node"$'\\\n  '
   fastly_ips_snippet="${fastly_ips_snippet}"$(printf '%-22s' "\\\"${ip}\\\";")"# Fastly cache node"$'\\\n  '
done

cp "${DIR}/datagovuk.vcl.tmp" "${DIR}/datagovuk.vcl"

sed -ie "s@<%= fastly_cache_node_subnets %>@${fastly_ips_snippet}@g" "${DIR}/datagovuk.vcl"

echo '{"fastly":"datagovuk.vcl"}'
