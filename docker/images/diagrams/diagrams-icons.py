# !/usr/bin/python

import os

githubrootpath="https://github.com/mingrammer/diagrams/blob/master/"

print("""
= List of icons

.Icons
|===
| Name | Icon

""")

for root, dirs, files in os.walk("resources", topdown=False):
    for name in files:
        print("| %s " % (root[10:] + name[:-4]))
        print("| image:%s[]" % (os.path.join(githubrootpath, root, name, "?raw=true")))
        print("\n")

print("""
|===
""")
