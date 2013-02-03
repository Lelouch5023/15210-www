#!/bin/sh
#
# Runs an local Apache server to test out your changes in www
# Should work on unix.andrew, GHC machines, and OS X
#

PORT=21080
DOCROOT=`(cd "$(dirname "$0")/.."; pwd)`
TMPDIR=`mktemp -d /tmp/tmp.XXXXXXXXXX`

MODULES=/usr/lib64/httpd/modules
if [ `uname -s` = "Darwin" ]; then MODULES=/usr/libexec/apache2/; fi
MIMETYPES=`ls /etc/mime.types || ls /etc/httpd/conf/mime.types || ls /etc/apache2/mime.types || ls /dev/null`

if [ "$1" ]; then DOCROOT="$1"; fi

echo "
Listen $PORT
ErrorLog /dev/stderr
LogLevel error
PidFile $TMPDIR/httpd.pid
LockFile $TMPDIR/accept21080.lock
DocumentRoot $DOCROOT
LoadModule authz_host_module $MODULES/mod_authz_host.so
LoadModule dir_module $MODULES/mod_dir.so
LoadModule mime_module $MODULES/mod_mime.so
LoadModule include_module $MODULES/mod_include.so
DirectoryIndex index.html
TypesConfig $MIMETYPES
AddType text/html .html
AddOutputFilter INCLUDES .html
" > "$TMPDIR/httpd.conf"

echo ""
echo "Access the page at http://`hostname`:$PORT/index.html"
echo "(or http://127.0.0.1:$PORT/index.html from this machine)"
echo "Press Ctrl-C to exit."
echo ""

trap "{ rm -Rf '$TMPDIR'; exit 0; }" 0 1 2 15
httpd -DFOREGROUND -f "$TMPDIR/httpd.conf"
