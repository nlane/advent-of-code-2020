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


// pt 2
// initialize memory dictionary
// loop through the program
// decode the mask as before
// get the memory and val as before
// turn the MEMORY address into the binary number
// change the logic inside of the for loop zip
// call helper function to find all the variations of the new value
// write the original value (not memory address) to all the variation addresses
// reduce at the end is the same

let program = process(input: input)
print(part1(program: program))
