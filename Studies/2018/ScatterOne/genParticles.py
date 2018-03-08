#!/usr/bin/env python3

import sys

from time    import time
from os      import path
from sttools import PartDist, Const

def genParticles(seedFile,outPath):
    
    distParam = {
        "energy"  : 10.0,
        "mass"    : 1.0,
        "gemit"   : [1.0, 1.0],
        "twalpha" : [0.0, 0.0],
        "sigmaz"  : 1.0,
        "spreade" : 1.0,
    }
    pDist = PartDist(distParam)
    pDist.setSeed(int(time()),seedFile)
    pDist.genDist(512)
    pDist.writeCollDist(outPath,512)
    
    return

if __name__ == "__main__":
    if len(sys.argv) == 3:
        seedFile = sys.argv[1]
        outPath  = sys.argv[2]
        genParticles(seedFile,outPath)
    else:
        print("Error: Seed file name missing")

# END Main
