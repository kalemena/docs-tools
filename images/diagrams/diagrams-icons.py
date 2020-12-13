# !/usr/bin/python

import os

githubrootpath="![](https://github.com/mingrammer/diagrams/blob/master/"

print("# List of icons")
for root, dirs, files in os.walk("resources", topdown=False):
    for name in files:
        print("Name: ", root[10:] + name[:-4], "icon: ", os.path.join(githubrootpath, root, name, "?raw=true)"))
