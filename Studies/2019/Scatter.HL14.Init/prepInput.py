#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from os import getcwd

from sttools.simtools import Fort2

currDir = getcwd()

geomFile = Fort2(currDir, "fc.2")
geomFile.loadFile()

geomFile.insertStruct("GO","ip3")

for n in [1,2,5,8]:
    ipName = "ip%d" % n
    ipScat = "ip%d_scatter" % n
    ipDump = "ip%d_dump" % n
    geomFile.insertElement(ipScat,40,[0,0,0,0,0,0],ipName,1)
    geomFile.insertStruct(ipScat,ipName,1,0)
    geomFile.insertElement(ipDump,0,[0,0,0,0,0,0],ipScat,1)
    geomFile.insertStruct(ipDump,ipScat,1,0)

geomFile.saveFile()
