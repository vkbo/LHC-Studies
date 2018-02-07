#!/usr/bin/env python3

import sys

from os import path

def prepareFort2(fileName, scatterPoint):
    
    whatStage = 0
    bufSingle = ""
    bufBlock  = ""
    bufStruct = ""
    arrStruct = []
    
    with open(fileName,"r") as inFile:
        for theLine in inFile:
            if   theLine[0:20] == "SINGLE ELEMENTS-----":
                whatStage = 1
                bufSingle = theLine
                print("Parsing single elements ...")
                continue
            elif theLine[0:20] == "BLOCK DEFINITIONS---":
                whatStage = 2
                bufBlock  = theLine
                print("Parsing block definitions ...")
                continue
            elif theLine[0:20] == "STRUCTURE INPUT-----":
                whatStage = 3
                bufStruct = theLine
                print("Parsing structure inputs ...")
                continue
            elif theLine[0:4]  == "NEXT":
                whatStage = 0
                
            if whatStage == 1:
                for p in range(len(scatterPoint)):
                    if theLine[0:4] == "ip%s " % scatterPoint[p]:
                        bufSingle += "ip%s_scatter       40   0.0  0.0  0.0  0.0  0.0  0.0\n" % scatterPoint[p]
                        print(" > Adding ip%s_scatter" % scatterPoint[p])
                bufSingle += theLine.replace("_AP   3   1.000000000e-08","_AP   0   0.000000000e+00")
            elif whatStage == 2:
                bufBlock  += theLine
            elif whatStage == 3:
                lineElems = theLine.split()
                for e in range(len(lineElems)):
                    for p in range(len(scatterPoint)):
                        if lineElems[e] == "ip%s" % scatterPoint[p]:
                            arrStruct.append("ip%s_scatter" % scatterPoint[p])
                            print(" > Adding ip%s_scatter" % scatterPoint[p])
                    arrStruct.append(lineElems[e])
    
    with open("fort.2.mod","w") as outFile:
        outFile.write(bufSingle)
        outFile.write("NEXT\n")
        outFile.write(bufBlock)
        outFile.write("NEXT\n")
        outFile.write(bufStruct)
        for i in range(len(arrStruct)):
            outFile.write("%-17s " % arrStruct[i])
            if (i+1)%3 == 0:
                outFile.write("\n")
            elif i+1 == len(arrStruct):
                outFile.write("\n")
        outFile.write("NEXT\n")

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
