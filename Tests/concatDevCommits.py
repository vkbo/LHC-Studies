#!/usr/bin/env python3

import sys

from os import path, listdir

def concatData(filePath):
    
    inFile   = open(filePath,mode="r")
    fileDir  = path.dirname(filePath)
    
    allData  = {}
    lineNo   = 0
    incTests = []
    incNums  = []
    
    GREEN    = "\033[0;32m"
    RED      = "\033[0;31m"
    BOLD     = "\033[0;1m"
    END      = "\033[0;0m"
    
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
        
        logFile   = open("%s/%s.out" % (fileDir,testNo),mode="r")
        logResult = {}
        for logLine in logFile:
            if logLine[4:10] == "Test #":
                logData    = logLine.split()
                testName   = logData[3]
                testStatus = logData[5].replace("***","")
                testTime   = logData[6]
                logResult[testName] = [testStatus, float(testTime)]
                if testName not in incTests:
                    incTests.append(testName)
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
    
    # print(allData)
    
    return

if __name__ == "__main__":
    if len(sys.argv) > 1:
        concatData(sys.argv[1])
    else:
        logger.error("Input file missing")
    
# END Main
