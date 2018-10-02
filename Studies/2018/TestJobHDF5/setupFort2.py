#!/usr/bin/env python3

import sys

from os                import path
from sttools.filetools import Fort2

def prepareFort2(fileName, scatterPoint):
    
    fTwo = Fort2("./",fileName)
    fTwo.loadFile()
    for p in range(len(scatterPoint)):
        elemRef  = "ip%s"         % scatterPoint[p]
        elemName = "ip%s_scatter" % scatterPoint[p]
        fTwo.insertElement(elemName,40,[0,0,0,0,0,0],elemRef,0)
        fTwo.insertStruct(elemName,elemRef,0)
    fTwo.saveFile("./","fort.2.mod")
    
    return

if __name__ == "__main__":
    if len(sys.argv) == 3:
        fileName     = sys.argv[1]
        scatterPoint = sys.argv[2]
        if path.isfile(fileName):
            prepareFort2(fileName, scatterPoint)
        else:
            print("Error: File not found")
    else:
        print("Error: File name missing")

# END Main
