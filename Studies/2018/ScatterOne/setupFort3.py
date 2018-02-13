#!/usr/bin/env python3

import sys

from os      import path
from sttools import Fort3, Aperture

def prepareFort3(fileName, scatterPoint):
    
    return

if __name__ == "__main__":
    if len(sys.argv) == 3:
        fileName     = sys.argv[1]
        scatterPoint = sys.argv[2]
        if path.isfile(fileName):
            prepareFort3(fileName, scatterPoint)
        else:
            print("Error: File not found")
    else:
        print("Error: File name missing")

# END Main
