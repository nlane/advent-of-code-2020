//
//  main.swift
//  day14
//
//  Created by Natalie Lane on 12/14/20.
//

import Foundation

func process(input: String) -> [ String ] {
    return input.components(separatedBy: "\n")
}

func padZeros(binaryNum: String, goalSize: Int) -> String {
  var zeros = ""
  for _ in 0..<(goalSize - binaryNum.count) {
    zeros += "0"
  }
    return zeros + binaryNum
}

func part1(program: [ String ]) -> Int {
    var currMask: String = ""
    var memToVals: [ Int: Int ] = [:]
    for line in program {
        if line.hasPrefix("mask") {
            currMask = String(line.split(separator: " ").last!)
        } else {
            // it's an instruction, extract the memory address and value from the string
            let addr = Int(line.split(separator: "[")[1].split(separator: "]")[0])!
            let val = Int(line.split(separator: " ").last!)!
            // convert the value to binary and pad the beginning with zeros
            let binVal = padZeros(binaryNum: String(val, radix: 2), goalSize: currMask.count)
            // zip the mask and binary value - create a new value based on both
            var newBinVal = ""
            for (binDigit, maskDigit) in zip(binVal, currMask) {
                newBinVal += maskDigit != "X" ? String(maskDigit) : String(binDigit)
            }
            // store the new value at its "memory address"
            memToVals[addr] = Int(newBinVal, radix: 2)
        }
    }
    // sum the values
    return memToVals.values.reduce(0, { (sum, x) in
        sum + x
    })
}

func calcAllVals(binStr: String, prevVals: inout [ Int ]) {
    if !binStr.contains("X") {
        prevVals.append(Int(binStr, radix: 2)!)
    } else {
        let xIdx = binStr.firstIndex(of: "X")!
        var binStr0 = binStr
        var binStr1 = binStr
        binStr0.replaceSubrange(xIdx...xIdx, with: "0")
        binStr1.replaceSubrange(xIdx...xIdx, with: "1")
        calcAllVals(binStr: binStr0, prevVals: &prevVals)
        calcAllVals(binStr: binStr1, prevVals: &prevVals)
    }
}

func part2(program: [ String ]) -> Int {
    var currMask: String = ""
    var memToVals: [ Int: Int ] = [:]
    for line in program {
        if line.hasPrefix("mask") {
            currMask = String(line.split(separator: " ").last!)
        } else {
            let addr = Int(line.split(separator: "[")[1].split(separator: "]")[0])!
            let val = Int(line.split(separator: " ").last!)!
            let binAddr = padZeros(binaryNum: String(addr, radix: 2), goalSize: currMask.count)
            var maskedAddr = ""
            for (addrDigit, maskDigit) in zip(binAddr, currMask) {
                maskedAddr += maskDigit == "0" ? String(addrDigit) : String(maskDigit)
            }
            var memAddrs: [Int] = []
            calcAllVals(binStr: maskedAddr, prevVals: &memAddrs)
            for address in memAddrs {
                memToVals[address] = val
            }
        }
    }
    return memToVals.values.reduce(0, { (sum, x) in
        sum + x
    })
}

let program = process(input: input)
print(part1(program: program))
print(part2(program: program))
