#!/bin/bash



pkg_path="./target/org.apache.sling.contrib.filters.blockallbutfelixconsole-1.0-SNAPSHOT.jar"
bundle_name="org.apache.sling.org.apache.sling.contrib.filters.blockallbutfelixconsole"
component_name="org.apache.sling.contrib.filters.blockallbutfelixconsole.BlockAllButFelixFilter"

usage() {
    echo "Usage: $0 start|stop|install [host:port [username:password]]"
}



if (( $# < 1 ))
then
    usage
    exit 1
fi


host="${2:-localhost:4502}"
cred="${3:-admin:admin}"

bundle_cmd() {
    local action="$1"
    local host="$2"
    local cred="$3"
    curl -f -s -d "action=$action"  -u "$cred" "http://$host/system/console/components/$component_name" > /dev/null 2>&1 || { echo "failed to $action $component_name" >&2; }
}

bundle_install() {
    local host="$1"
    local cred="$2"
    curl -f -s -F"action=install" -F"bundlefile=@$pkg_path" -F"bundlestart=start" -F"bundlestartlevel=10" -F"refreshPackages=true" -u"$cred" "http://$host/system/console/install" > /dev/null 2>&1 || { echo "failed to install: $pkg_path" >&2; }
}



case "$1" in
    start)
        bundle_cmd enable "$host" "$cred"
        ;;
    stop)
        bundle_cmd disable "$host" "$cred"
        ;;
    install)
        bundle_install "$host" "$cred"
        ;;
    *)
        usage
        exit 1
        ;;
esac


