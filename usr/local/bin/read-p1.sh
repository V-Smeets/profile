#!/bin/sh
#
/bin/stty --file /dev/ttyUSB0 115200 cs8 -icrnl
exec /bin/cat /dev/ttyUSB0 > "/var/log/read-p1/p1-telegrams.$(date +"%F.%T").log"
