#!/usr/bin/env python3

import sys

from os      import path
from sttools import Fort3, Aperture

def prepareFort3(aperFile, fileName, scatterPoint):
    
    bufFort3 = ""
    bufLIMI  = ""
    with open(aperFile,mode="r") as inFile:
        bufLIMI = inFile.read()
    with open("fort.3",mode="r") as inFile:
        bufFort3 = inFile.read()
    with open("fort.3.mod",mode="w") as outFile:
        bufFort3 = bufFort3.replace("%IP%","ip%s" % scatterPoint)
        bufFort3 = bufFort3.replace("%LIMI%",bufLIMI.strip())
        outFile.write(bufFort3)
    
    return

if __name__ == "__main__":
    if len(sys.argv) == 4:
        aperFile     = sys.argv[1]
        fileName     = sys.argv[2]
        scatterPoint = sys.argv[3]
        if path.isfile(fileName):
            prepareFort3(aperFile, fileName, scatterPoint)
        else:
            print("Error: File not found")
    else:
        print("Error: File name missing")

# END Main
