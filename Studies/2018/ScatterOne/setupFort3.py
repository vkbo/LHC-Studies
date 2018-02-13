#!/usr/bin/env python3

import sys

from os      import path
from sttools import Fort3, Aperture

def prepareFort3(aperFile, fileName, scatterPoint):
    
    fThree = Fort3("./","fort.3")
    fThree.loadFile()
    
    beamOne = Aperture("./",aperFile)
    qPoles  = beamOne.aperData.findDataIndex("KEYWORD","QUADRUPOLE")
    for qIndex in qPoles:
        qMarker = beamOne.aperData.Data["NAME"][qIndex].lower()
        fThree.appendToBlock("DUMP",-1,"%-18s 1 650 2 dump.txt 11 11" % qMarker+"..1")
    
    fThree.saveFile("./","fort.3.mod")
    
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
