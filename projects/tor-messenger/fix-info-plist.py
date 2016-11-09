#!/usr/bin/env python

# Sets these keys in a property list file:
#   CFBundleGetInfoString
#   CFBundleShortVersionString
#   NSHumanReadableCopyright

import getopt
import plistlib
import sys

def usage():
    print >> sys.stderr, "usage: %s TORBROWSER_VERSION YEAR < Info.plist > FixedInfo.plist" % sys.argv[0]
    sys.exit(2)

_, args = getopt.gnu_getopt(sys.argv[1:], "")

if len(args) != 2:
    usage()

TORBROWSER_VERSION = args[0]
YEAR = args[1]

COPYRIGHT = "Tor Messenger %s Copyright %s The Tor Project" % (TORBROWSER_VERSION, YEAR)

plist = plistlib.readPlist(sys.stdin)

plist["CFBundleGetInfoString"] = "Tor Messenger %s" % TORBROWSER_VERSION
plist["CFBundleVersion"] = TORBROWSER_VERSION
plist["CFBundleShortVersionString"] = TORBROWSER_VERSION
plist["NSHumanReadableCopyright"] = COPYRIGHT

plistlib.writePlist(plist, sys.stdout)
