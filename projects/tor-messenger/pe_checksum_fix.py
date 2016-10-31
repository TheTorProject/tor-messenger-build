#!/usr/bin/env python

# Copyright (c) 2015, The Tor Project, Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#
#     * Neither the names of the copyright owners nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
NSIS is neither padding nor calculating the PE-file checksum. But the tool
we use for signing and the tools for stripping the signature do which leads to a
SHA256 mismatch if one tries to check that the binary we offer is actually the
the one we got from our reproducible builds.

This small Python snippet does both things: It pads the .exe if necessary and it
recalculates the PE-file checksum. Details of the discussion can be foun in bug
15339: https://bugs.torproject.org/15539.

Thanks to a cypherpunk for this workaround idea.
"""

import pefile;

f = open('tor-messenger-install-tmp.exe')
exe = f.read()
f.close()
remainder = len(exe) % 8
if remainder > 0:
    exe += '\0' * (8 - remainder)
pef = pefile.PE(data=exe, fast_load=True)
pef.OPTIONAL_HEADER.CheckSum = pef.generate_checksum()
pef.write(filename='tor-messenger-install-tmp2.exe')
