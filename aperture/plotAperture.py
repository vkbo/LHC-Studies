#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import sys

from sttools import TableFS, logger
from os      import path
from array   import array
from ROOT    import gROOT, TCanvas, TGraph

def plotAperture(aperFile, pltBlock=False):
    
    if not path.isfile(aperFile):
        logger.error("File not found %s" % aperFile)
        return
    
    aperData = TableFS(aperFile)
    aperData.fileInfo()
    
    aperS = array("d")
    aperX = array("d")
    aperY = array("d")
    
    for n in range(aperData.nLines):
        
        aperName = aperData.Data["NAME"][n]
        aperKeyw = aperData.Data["KEYWORD"][n]
        aperType = aperData.Data["APERTYPE"][n]
        
        aperS.append(aperData.Data["S"][n])
        
        if   aperType == "RECTELLIPSE":
            aperX.append(min(aperData.Data["APER_1"][n],aperData.Data["APER_3"][n]))
            aperY.append(min(aperData.Data["APER_2"][n],aperData.Data["APER_4"][n]))
        elif aperType == "NONE":
            aperX.append(0.0)
            aperY.append(0.0)
        else:
            logger.warning("Unhandled APERTYPE '%s'" % aperType)
            aperX.append(0.0)
            aperY.append(0.0)
            
        # if n >= 100: break
        
    for n in range(aperData.nLines):
        
        aperName = aperData.Data["NAME"][n]
        aperKeyw = aperData.Data["KEYWORD"][n]
        aperType = aperData.Data["APERTYPE"][n]
        
        if aperKeyw == "DRIFT" and n < len(aperX) - 1:
            aperX[n] = aperX[n+1]
            aperY[n] = aperY[n+1]
        
        # print("%16s [%12s] %12s: s=%18.11e x=%18.11e y=%18.11e" % (aperName,aperKeyw,aperType,aperS[n],aperX[n],aperY[n]))
        # if n >= 100: break
        
    gROOT.Reset()
    cnvMain = TCanvas("c1", "Aperture", 200, 10, 700, 500)
    tAperX  = TGraph(len(aperS),aperS,aperX)
    tAperY  = TGraph(len(aperS),aperS,aperY)
    tAperX.Draw()
    tAperY.Draw()
    cnvMain.Update()
    input("Press Enter to close ...")
    
    return

if __name__ == "__main__":
    if len(sys.argv) > 1:
        plotAperture(sys.argv[1],True)
    else:
        logger.error("File name missing")
    
# END Main
