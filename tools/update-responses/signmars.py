#! /usr/bin/env python

"""signmars.py checks and signs the MAR files that are used by Tor Messenger's
updater. This script borrows from Tor Browser's signmars.sh but was rewritten
in Python because our build and signing requirements are different.

This script should be run offline -- do not copy the NSS_DB_DIR to any remote
machine.

Before running it, put the unsigned MAR files (both complete and partial) in
the current directory. Also set NSS_DB_DIR (export) and point it to the
directory with the private key (directory with cert8.db). The NSS_CERT_NAME is
set to "marsigner" by default and assumes you will be signing the primary
certificate; change it to "marsigner1" in case you are signing the secondary
certificate.

You will need mar-tools-linux32.zip or mar-tools-linux64.zip, depending on
which platform you are running the script. These files are generated as part
of the build process. 'signmar' and other dependencies are then extracted from
the ZIP file.

If a MAR file is already signed, it is moved to the signed/ directory.
If a MAR file is not signed, it is signed and moved to the signed/ directory.

The MAR files in the directory in which the script is run are not modified.
"""

import os
import sys
import glob
import shlex
import shutil
import zipfile
import getpass
import subprocess

MAR_TOOLS = "mar-tools"
MAR_SIGN = './signmar -d "{0}" -n "{1}" -s {2} {3}'
MAR_SIGN_CHECK = './signmar -T {0}'

NSS_CERT_NAME = "marsigner"

OUTPUT_DIR = "signed"


def sign_mars():
    if "NSS_DB_DIR" not in os.environ:
        sys.exit("Please set `export NSS_DB_DIR' before running this script.")
    else:
        nss_dir = os.environ["NSS_DB_DIR"]
    if not os.path.isdir(nss_dir):
        sys.exit("The {0} directory does not exist.".format(nss_dir))
    if not os.path.isfile(os.path.join(nss_dir, "cert8.db")):
        sys.exit("The {0} directory has not been populated.".format(nss_dir))

    # Look for a mar-tools-linux$ARCH.zip and extract it.
    os_name, arch = os.uname()[0], os.uname()[-1]
    if not os_name == "Linux":
        sys.exit("Unsupported architecture {0}".format(os_name))
    if arch == "x86_64":
        os_name = "linux64"
    else:
        os_name = "linux32"
    mar_zip = "mar-tools-{0}.zip".format(os_name)
    try:
        with zipfile.ZipFile(mar_zip, "r") as zip_f:
            zip_f.extractall(os.getcwd())
    except IOError:
        sys.exit("File {0} not found.".format(mar_zip))

    # Copy the so files from the mar-tools directory.
    so_files = glob.glob(os.path.join(MAR_TOOLS, "*.so"))
    for each in so_files:
        shutil.copy(each, os.getcwd())
    # Copy the signmar as well.
    shutil.copy(os.path.join(MAR_TOOLS, "signmar"), os.getcwd())
    # Set its permission bit.
    os.chmod("signmar", 0o755)

    # Remove the mar-tools directory.
    shutil.rmtree(MAR_TOOLS)

    # If there are no MAR files, quit before doing anything else.
    mar_files = glob.glob("*.mar")
    if not mar_files:
        sys.exit("No MAR files found.")

    os.environ["LD_LIBRARY_PATH"] = os.getcwd()

    # Check if the MARs are already signed; if so, quit.
    print "Checking for existing signatures..."
    already_signed = []
    for each in mar_files:
        process = subprocess.Popen(shlex.split(MAR_SIGN_CHECK.format(each)),
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = process.communicate()
        if err:
            print err
            sys.exit("Unable to run signmar to verify the signatures.")
        out = out.split('\n')[0]

        # FIXME: This is a very poor hack to check for signatures that
        # currently works but will fail if the files are 10 or 20.
        if "0" in out:
            print " [NOT signed] {0}".format(each)
        else:
            print " [signed] {0}".format(each)
            already_signed.append(each)

    num_to_sign = len(mar_files) - len(already_signed)
    if not num_to_sign:
        sys.exit("All MAR files are already signed.")

    print "\n{0} MAR files, {1} signed, {2} not signed".format(len(mar_files),
                                                               len(already_signed),
                                                               num_to_sign)

    passwd = getpass.getpass("\nEnter the MAR signing key password:\n")
    if not passwd:
        sys.exit("MAR signing key password not entered.")

    try:
        os.mkdir(OUTPUT_DIR)
    except OSError:
        print "The '{0}' directory already exists " \
                "and its MAR files will be overwritten!".format(OUTPUT_DIR)
        answer = raw_input("Proceed? [y/N]: ") or "n"
        if answer not in ('y', 'yes'):
            sys.exit()

    print "\nStarting MAR signing for {0} files...".format(num_to_sign)
    print "(Assuming NSS_CERT_NAME as '{0}')\n".format(NSS_CERT_NAME)
    for each in mar_files:
        if each in already_signed:
            print " [move] '{0}'".format(each)
            shutil.copy(each, os.path.join(OUTPUT_DIR, each))
        else:
            process = subprocess.Popen(shlex.split(MAR_SIGN.format(nss_dir,
                                       NSS_CERT_NAME, each,
                                       os.path.join(OUTPUT_DIR, each))),
                                       stdin=subprocess.PIPE,
                                       stderr=subprocess.PIPE,
                                       env=os.environ)
            process_in, process_err = process.communicate(input=passwd)
            if process_err:
                print process_err
                sys.exit("MAR signing could not be completed.")
            print " [sign and move] '{0}'".format(each)

    sys.exit("\nSigned MAR files saved to '{0}'".format(os.path.abspath(OUTPUT_DIR)))

if __name__ == "__main__":
    sign_mars()
