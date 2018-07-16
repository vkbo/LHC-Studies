#!/usr/bin/env python3

import sys

from os import path

def prepareFort3(scatterPoint, tMin):

    bufFort3 = ""
    with open("fort.3",mode="r") as inFile:
        bufFort3 = inFile.read()
    with open("fort.3.mod",mode="w") as outFile:
        bufFort3 = bufFort3.replace("%IP%","ip%s" % scatterPoint)
        bufFort3 = bufFort3.replace("%TMIN%",tMin)
        outFile.write(bufFort3)

    return

if __name__ == "__main__":
    if len(sys.argv) == 3:
        scatterPoint = sys.argv[1]
        tMin         = sys.argv[2]
        prepareFort3(scatterPoint,tMin)
    else:
        print("Error: Wrong number of input parameters")

# END Main
