#!/usr/bin/env bash

CLI_DIR=/usr/share/cacti/cli/

PHP_RUN="php -q"
ADD_DEV="${PHP_RUN} ${CLI_DIR}add_device.php"
ADD_TRE="${PHP_RUN} ${CLI_DIR}add_tree.php"
ADD_GRA="${PHP_RUN} ${CLI_DIR}add_graphs.php"

# Some hardcoded template IDs
TMPL_NONE=0
PING_TMPL_ID=7

if [ $# -eq 0 ]; then
    echo "usage:"
    echo "$0 --file path/to/tab-delimited/file [--graph-template-id ID]"
    echo "    File should contain lines in the following format:"
    echo "    Description<tab>Hostname<tab>Template ID<tab>Tree ID<tab>Node ID"
    echo "    --graph-template-id graph template ID for Ping graph (7 by default)"
    echo
    echo "$0 list"
    echo "    to list available IDs"
    exit
elif [ "$1" == "list" ]; then
    echo "Use one of the following template IDs:"
    ${ADD_DEV} --list-host-templates

    echo "Use one of the following Tree IDs:"
    ${ADD_TRE} --list-trees

    echo "Use one of the following Node IDs:"
    OUT=$(${ADD_TRE} --list-trees | grep '^[0-9]')
    IDs=$(echo "${OUT}" | cut -f1)
    NMs=$(echo "${OUT}" | cut -f3)
    COUNT=1
    for ID in $IDs; do
        echo "$(echo "${NMs}" | sed -n "${COUNT}p") (Tree ID=${ID})"
        ${ADD_TRE} --list-nodes --tree-id=${ID}
        ((COUNT++))
    done
    exit
fi
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -f|--file)
        FILE="$2"
        shift # past argument
        ;;
    -g|--graph-template-id)
        PING_TMPL_ID="$2"
        shift # past argument
        ;;
    *)
        echo "Could not understand ($1). Exiting"
        exit
        ;;
    esac
    shift # past argument or value
done

while read DESC HOST TREE PARENT; do
    # Trying to add a device
    ANS=$(${ADD_DEV} --description=${DESC} --ip=${HOST} --template=${TMPL_NONE} --avail=ping --ping_method=icmp --quiet)
    echo "$ANS"

    # Getting device ID
    DEV_ID=$(echo "$ANS" | grep ^Success | grep -o '([0-9]*)' | tr -d "()")
    # Skipping if device ID could not be determined
    if [ -z "${DEV_ID}" ]; then echo "Skipping..."; continue; fi
    echo "DEV_ID=${DEV_ID}"

    # Adding ping graph for new device
    ${ADD_GRA} --graph-type=cg --graph-template-id=${PING_TMPL_ID} --host-id=${DEV_ID}

    # Adding device to tree
    ${ADD_TRE} --type=node --node-type=host --tree-id=${TREE} --parent-node=${PARENT} --host-id=${DEV_ID} --quiet
done < ${FILE}
