#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np

from sttools import STDump, Twiss
from os import path

def plotScatterLog(pltBlock=False):

    simPath = "/scratch/SixTrack/SCAT-01A"
    stDump = STDump(path.join(simPath,"dump.txt"))
    stScat = STDump(path.join(simPath,"scatter_log.txt"))
    
    stDump.readAll()
    stScat.readAll()
    
    turns = range(1,20)

    xRMS  = []
    yRMS  = []
    xBeta = []
    yBeta = []
    xEmit = []
    yEmit = []
    
    xNorm = 1.0
    yNorm = 1.0
    
    for turn in turns:
        stDump.filterPart("TURN",turn)
        theTwiss = Twiss(stDump)
        xBeta.append((theTwiss.getTwiss("X",turn))["Beta"]/10)
        yBeta.append((theTwiss.getTwiss("Y",turn))["Beta"]/10)
        xEmit.append((theTwiss.getTwiss("X",turn))["GEmit"]*1000)
        yEmit.append((theTwiss.getTwiss("Y",turn))["GEmit"]*1000)
        xRMS.append(np.std(stDump.filData["X"]))
        yRMS.append(np.std(stDump.filData["Y"]))
        
    xRMS = xRMS/xRMS[0]
    yRMS = yRMS/yRMS[0]
    
    fig1 = plt.figure(1)
    fig1.clf()
    plt.plot(turns,xRMS)
    plt.plot(turns,yRMS)
    plt.ylim(0,11)
    plt.xlabel("Turn")
    plt.ylabel("Sigma/Sigma(0)")
    
    fig2 = plt.figure(2)
    fig2.clf()
    plt.plot(turns,xBeta)
    plt.plot(turns,yBeta)
    plt.ylim(0,90)
    plt.xlabel("Turn")
    plt.ylabel("Beta [cm]")
    
    fig3 = plt.figure(3)
    fig3.clf()
    plt.plot(turns,xEmit)
    plt.plot(turns,yEmit)
    plt.ylim(0,5)
    plt.xlabel("Turn")
    plt.ylabel("Emittance [nm]")
    
    plt.show(block=pltBlock)
    
    return

if __name__ == "__main__":
    plotScatterLog(True)
