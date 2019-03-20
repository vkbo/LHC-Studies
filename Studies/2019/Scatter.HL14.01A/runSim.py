#!/usr/bin/env python3
# -*- coding: utf-8 -*
"""
SixTrack Simulation Scatter.03A
SingleDiffractive with higher statistics than Scatter.02A
"""

from sttools          import loggingConfig
from sttools.simtools import SixTrackJob

loggingConfig("INFO", toStd=False, logFile="simJobs.log")

partDist = {
    "sigmaxxp" : [1.0, 1.0],
    "sigmayyp" : [1.0, 1.0],
    "sigmaz"   : 1.0,
    "spreadp"  : 1.0,
}

stJob = SixTrackJob(".")
stJob.setOutput("Run", SixTrackJob.OUT_HDF5)
stJob.setExecutable("SixTrack-5.0.2-c2bd6e4.PYTHIA-HDF5.Linux64.e")
stJob.setPartGen(SixTrackJob.GEN_COLL, partDist)
stJob.setNPart(10000)
stJob.setNTurn(20)
stJob.addSeed(["%SEED1%","%SEED2%","%SEED3%"])
stJob.initSeeds(42,7)
stJob.addInputFile(["fort.2","aperLimi.dat","CollDB-HLLHC.dat"])
stJob.addOutputFile(["fort.3","dynksets.dat","partDist.dat"])
stJob.addSimValue("%H5OPTICS%","WRITE OPTICS",simID=1)
stJob.addSimValue("%LIMIPRINT%","PRINT",simID=1)
stJob.addSimValue("%IP%","ip5")
stJob.addSimValue("%ENERGY%","7000000.0")
stJob.addSimValue("%TMIN%","0.0")
stJob.setCleanup(True)
stJob.setEchoJobLog(True)

stJob.runParallel(50,2)
