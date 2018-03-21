#!/usr/bin/env python3

import sys
import numpy as np
import matplotlib.pyplot as plt

from os import path, listdir

def concatData(dataPath, withColor, withPlot):
    
    #
    #  Read all Commit Messages
    #
    
    comFile  = open(path.join(dataPath,"commits.out"),mode="r")
    comMsg   = {}
    for comLine in comFile:
        comMsg[comLine[0:40]] = [
            comLine[41:66].strip(),
            comLine[68:].strip()
        ]
    comFile.close()
    
    #
    #  Loop Through Summary File
    #
    
    inFile   = open(path.join(dataPath,"summary.out"),mode="r")
    allData  = {}
    lineNo   = 0
    incTests = []
    incNums  = []
    plotData = {}
    
    if withColor:
        RED    = "\033[0;31m"
        GREEN  = "\033[0;32m"
        YELLOW = "\033[0;33m"
        BLUE   = "\033[0;34m"
        CYAN   = "\033[0;36m"
        BOLD   = "\033[0;1m"
        END    = "\033[0;0m"
    else:
        RED    = ""
        GREEN  = ""
        YELLOW = ""
        BLUE   = ""
        CYAN   = ""
        BOLD   = ""
        END    = ""
    
    for inLine in inFile:
        
        lineNo += 1
        if lineNo <= 5:
            continue
        
        lineData  = inLine.split("|")
        testNo    = lineData[0].strip()
        testPass  = lineData[1].strip()
        totalTime = float(lineData[2].strip())
        fastTime  = float(lineData[3].strip())
        mediTime  = float(lineData[4].strip())
        commitNo  = lineData[5].strip()
        commitMsg = lineData[6].strip()
        incNums.append(testNo)
        
        logFile   = open(path.join(dataPath,testNo+".out"),mode="r")
        logResult = {}
        for logLine in logFile:
            if logLine[4:10] == "Test #":
                logLine    = logLine.replace("***","   ")
                logData    = logLine.split()
                testName   = logData[3]
                testStatus = logData[5]
                testTime   = float(logData[6])
                logResult[testName] = [testStatus, float(testTime)]
                if testName not in incTests:
                    incTests.append(testName)
                    plotData[testName] = []
                plotData[testName].append(testTime)
        logFile.close()
        
        allData[testNo] = {
            "pass"       : testPass,
            "total"      : totalTime,
            "fast"       : fastTime,
            "medium"     : mediTime,
            "commitHash" : commitNo,
            "commitMsg"  : commitMsg,
            "results"    : logResult
        }
    
    inFile.close()
    
    #
    #  Print Data Summary
    #
    
    print("")
    print(" Commit Hash and Message")
    print("*************************")
    for testNo in incNums:
        print((BOLD+"%4s"+END+" "+YELLOW+"%s"+END+" "+CYAN+"%-20s"+END+" %s") % (
            testNo,
            allData[testNo]["commitHash"],
            comMsg[allData[testNo]["commitHash"]][0][0:20],
            comMsg[allData[testNo]["commitHash"]][1][0:64]
            # allData[testNo]["commitMsg"]
        ))
    print("")
    print(
        " "+BOLD+"Test"+END+" |" + 
        ((" "+BOLD+"%10s"+END+" |")*len(incTests) % tuple(incTests)) + 
        "      "+BOLD+"Total"+END+" "
    )
    print("======|"+("============|"*len(incTests))+"============")
    for testNo in incNums:
        totTime = 0.0
        toPrint = " %4s |" % testNo
        for testName in incTests:
            testTime = allData[testNo]["results"][testName][1]
            testPass = allData[testNo]["results"][testName][0] == "Passed"
            if testPass:
                toPrint += (" "+GREEN+"%8.2f s"+END+" |") % testTime
            else:
                toPrint += (" "+RED+"%8.2f s"+END+" |") % testTime
            totTime += testTime
        toPrint += " %8.2f s" % totTime
        print(toPrint)
    print("")
    
    #
    #  Plot Data
    #
    
    if not withPlot:
        return
    
    # Commit: 59731194d20ca80daeb0a50fd03148f23d2ecc4c on Sun Oct 22 19:34:31 2017
    refTime = {
        "lostnotilt" :  7.62,
        "lostnumxv"  :  8.62,
        "bb"         : 11.23,
        "notilt"     : 11.42,
        "s316"       : 23.27,
        "tilt"       : 69.83,
        "dipedge"    : 80.55,
        "bbe571ib0"  : 98.90
    }
    
    xAxis = range(len(incNums))
    for testName in incTests:
        yAxis = np.array(plotData[testName])
        #rTime = yAxis[-1]
        rTime = refTime[testName]
        yAxis = 100*yAxis/rTime
        plt.step(xAxis, yAxis, label=testName)
    
    plt.legend()
    plt.title("SixTrack Performance")
    plt.xlabel("Commits Behind DEV")
    plt.ylabel("Relative Time [%]")
    
    plt.show(block=True)
    
    return

if __name__ == "__main__":
    if len(sys.argv) > 1:
        withColor = False
        withPlot  = False
        for inArg in sys.argv[2:]:
            if inArg in ("--color","--colour"):
                withColor = True
            if inArg in ("--plot"):
                withPlot  = True
        concatData(sys.argv[1],withColor,withPlot)
    else:
        logger.error("Input file missing")
    
# END Main
