#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Sep  5 15:28:30 2018

@author: vkbo
"""

import matplotlib.pyplot as plt

from sttools import loggingConfig, SixTrackSim, DataSet
from sttools.analysis import Beams

loggingConfig("DEBUG")

stSim = SixTrackSim("/scratch/SixTrack/Scatter/Scatter.01C/simResults")
print(stSim)

aBeam = Beams(stSim)
bData = aBeam.plotSixDim("dist0")
#print(bData)

#fig1, ax1 = plt.subplots(figsize=(7, 8),dpi=100)
#ax1.step(range(100),bData[0][0])

#plt.draw()
#plt.show(block=True)
