Tor Messenger Build
===================

Installing build dependencies
-----------------------------

To build Tor Messenger, you need a Linux distribution that has support for
runc (such as Debian jessie, Ubuntu 14.04, Fedora 20, etc ...).

On Debian jessie, the runc package is available in backports. On Debian
stretch, the runc package is available in the main repository.
Version 0.1.1 of runc is required (which is the version available in
Debian stretch and jessie-backports). It is not yet working with runc
version 1.0.0: https://trac.torproject.org/projects/tor/ticket/23039

Your user account should have access sudo access, which is required to
be able to extract container file systems, start containers and copy
files to and from containers.

The sources are downloaded using git and mercurial which need to be
installed.

```
If you are running Debian or Ubuntu, you can install the build dependencies
with the following command:
```
# apt-get install libyaml-libyaml-perl libtemplate-perl \
                  libio-handle-util-perl libio-all-perl \
                  libio-captureoutput-perl libfile-slurp-perl \
                  libstring-shellquote-perl libsort-versions-perl \
                  libdigest-sha-perl libdata-uuid-perl libdata-dump-perl \
                  libfile-copy-recursive-perl git libgtk2.0-dev curl runc \
                  mercurial
```

Starting a build
----------------

To start a build, simply run `make all` in the directory to build all
currently supported architectures.

If you want to build only one architecture, you can run something like
`make tor-messenger-linux-x86_64`.

The resulting builds are stored in the out/tor-messenger directory.

You can also run `make tor-messenger-release` to build it for all
architectures, rename files to their final name and generate an
sha256sums.txt file in the directory release/$version.


Updating git and hg sources
---------------------------

You can run `make fetch` to fetch the latest sources from git and
mercurial for all components included in Tor Messenger.


Cleaning obsolete files and containers images
---------------------------------------------

To clean obsolete files and containers images, you can run `make clean-old`.

This command will remove any intermediate build files and containers
that are no longer used in the current builds. Because it needs to
compute the filename of all current files, this command takes a lot of
time to run.

