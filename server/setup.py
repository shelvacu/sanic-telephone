#!/usr/bin/env python3

import os, sys

picDir = os.path.dirname(os.path.realpath(sys.argv[0])) + '/pics'

if not os.path.isdir(picDir):
    os.makedirs(picDir)

os.chmod(picDir, 0o766)
