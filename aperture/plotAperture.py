#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import sys

from sttools import TableFS, logger
from os      import path

def plotAperture(aperFile, pltBlock=False):
    
    if not path.isfile(aperFile):
        logger.error("File not found %s" % aperFile)
        return
    
    aperData = TableFS(aperFile)
    aperData.fileInfo()
    
    return

if __name__ == "__main__":
    if len(sys.argv) > 1:
        plotAperture(sys.argv[1],True)
    else:
        logger.error("File name missing")
    
# END Main
