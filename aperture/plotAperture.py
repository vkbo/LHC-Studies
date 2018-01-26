#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import sys

from sttools import TableFS, Aperture, logger
from os      import path
from array   import array
from numpy   import ma

def plotApertureTest(aperFile, pltBlock=False):
    
    aperData = Aperture(aperFile)
    aperData.parseAperture()
    
    return

def plotAperture(aperFile, pltBlock=False):
    
    if not path.isfile(aperFile):
        logger.error("File not found %s" % aperFile)
        return
    
    aperData = TableFS(aperFile)
    aperData.fileInfo()
    
    aperS = np.array([])
    aperX = np.array([])
    aperY = np.array([])
    
    for n in range(aperData.nLines):
        
        aperName = aperData.Data["NAME"][n]
        aperKeyw = aperData.Data["KEYWORD"][n]
        aperType = aperData.Data["APERTYPE"][n]
        
        aperS = np.append(aperS,aperData.Data["S"][n])
        
        if   aperType == "CIRCLE":
            aperX = np.append(aperX,aperData.Data["APER_1"][n])
            aperY = np.append(aperY,aperData.Data["APER_1"][n])
        elif aperType == "RECTANGLE":
            aperX = np.append(aperX,aperData.Data["APER_1"][n])
            aperY = np.append(aperY,aperData.Data["APER_2"][n])
        elif aperType == "ELLIPSE":
            aperX = np.append(aperX,aperData.Data["APER_1"][n])
            aperY = np.append(aperY,aperData.Data["APER_2"][n])
        elif aperType == "RECTELLIPSE":
            aperX = np.append(aperX,min(aperData.Data["APER_1"][n],aperData.Data["APER_3"][n]))
            aperY = np.append(aperY,min(aperData.Data["APER_2"][n],aperData.Data["APER_4"][n]))
        elif aperType == "RACETRACK":
            aperX = np.append(aperX,aperData.Data["APER_1"][n]+aperData.Data["APER_3"][n])
            aperY = np.append(aperY,aperData.Data["APER_2"][n]+aperData.Data["APER_4"][n])
        elif aperType == "NONE":
            aperX = np.append(aperX,0.0)
            aperY = np.append(aperY,0.0)
        else:
            logger.warning("Unhandled APERTYPE '%s'" % aperType)
            aperX = np.append(aperX,9.999)
            aperY = np.append(aperY,9.999)
            
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
        
    aperX = ma.masked_where(aperX > 9.9, aperX)
    aperY = ma.masked_where(aperY > 9.9, aperY)
    
    plt.step(aperS, aperX*1e3, label="X Aperture")
    plt.step(aperS, aperY*1e3, label="Y Aperture")
    
    plt.xlim(aperS[0], aperS[aperData.nLines-1])

    plt.legend()
    plt.title("Aperture")
    plt.xlabel("s [m]")
    plt.ylabel("x, y [mm]")
    
    plt.show(block=pltBlock)
    
    return

if __name__ == "__main__":
    if len(sys.argv) > 1:
        plotApertureTest(sys.argv[1],True)
    else:
        logger.error("File name missing")
    
# END Main
