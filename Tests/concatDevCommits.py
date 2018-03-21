#!/usr/bin/env python3

import sys

from os import path, listdir

def concatData(filePath):
    
    inFile  = open(filePath,mode="r")
    fileDir = path.dirname(filePath)
    allData = {}
    lineNo  = 0
    for inLine in inFile:
        lineNo += 1
        if lineNo > 5:
            lineData  = inLine.split("|")
            testNo    = lineData[0].strip()
            testPass  = lineData[1].strip()
            totalTime = float(lineData[2].strip())
            fastTime  = float(lineData[3].strip())
            mediTime  = float(lineData[4].strip())
            commitNo  = lineData[5].strip()
            commitMsg = lineData[6].strip()
            
            logFile   = open("%s/%s.out" % (fileDir,testNo),mode="r")
            logResult = {}
            for logLine in logFile:
                if logLine[4:10] == "Test #":
                    logData    = logLine.split()
                    testName   = logData[3]
                    testStatus = logData[5].replace("***","")
                    testTime   = logData[6]
                    logResult  = {
                        "name"   : testName,
                        "status" : testStatus,
                        "time"   : float(testTime)
                    }
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
    
    print(allData)
    
    inFile.close()
    
    return

if __name__ == "__main__":
    if len(sys.argv) > 1:
        concatData(sys.argv[1])
    else:
        logger.error("Input file missing")
    
# END Main
