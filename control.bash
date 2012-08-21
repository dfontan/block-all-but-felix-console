#!/bin/bash



pkg_path="./target/org.apache.sling.contrib.filters.blockallbutfelixconsole-1.0-SNAPSHOT.jar"
bundle_name="org.apache.sling.org.apache.sling.contrib.filters.blockallbutfelixconsole"
cred="admin:admin"
host="localhost:4502"

bundle_cmd() {
    action="$1"
    curl -f -s -d "action=$action"  -u "$cred" "http://$host/system/console/bundles/$bundle_name" > /dev/null 2>&1 || { echo "failed to $action $bundle_name" >&2; }
}

bundle_install() {
    curl -f -s -F"action=install" -F"bundlefile=@$pkg_path" -F"bundlestart=start" -F"bundlestartlevel=20" -F"refreshPackages=true" -u"$cred" "http://$host/system/console/install" > /dev/null 2>&1 || { echo "failed to install: $pkg_path" >&2; }
}

usage() {
    echo "Usage: $0 start|stop|install"
}

if (( $# < 1 ))
then
    usage
    exit 1
fi

case "$1" in
    start)
        bundle_cmd start
        ;;
    stop)
        bundle_cmd stop
        ;;
    install)
        bundle_install
        ;;
    *)
        usage
        exit 1
        ;;
esac


