#!/bin/bash

set -e

reporoot="$(git rev-parse --show-toplevel)"
lang="${1}"
if [ -z "${2}" ]
then
    texdir="/content/english"
else
    texdir="${2}"
fi
echo "Checking files in ${reporoot}${texdir}"
for i in $(find "${reporoot}${texdir}" -type f -iname "*.md")
do
    tmp="$(cat "${i}" | aspell -M -a --lang="${lang}" --encoding=utf-8 --add-extra-dicts="${reporoot}/tools/dictionary.$1.pws" 2>/dev/null | grep -v "*" | grep -v "@" | grep -v "+" | sed '/^\s*$/d')"
    if [ "${tmp}" != "" ]
    then
        echo "******* List of errors detected for ${i} *******"
        echo "${tmp}"
        exit 1
    else
        echo "${i} OK"
    fi
done
