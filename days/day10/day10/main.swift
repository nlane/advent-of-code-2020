//
//  main.swift
//  day10
//
//  Created by Natalie Lane on 12/10/20.
//

import Foundation

func processInput(input: String) -> [ Int ] {
    return input.split(separator: "\n").map{ Int($0)! }
}

func calculateVoltage(input: [ Int ]) -> Int {
    let sortedInput = input.sorted()
    var oneV = 0, threeV = 1, previous = 0
    for num in sortedInput {
        if (num - previous) == 1 {
            oneV += 1
        } else if (num - previous) == 3 {
            threeV += 1
        }
        previous = num
    }
    return oneV * threeV
}

func findAllPerms(input: [ Int ]) -> Int{
    var sortedNums = input
    sortedNums.append(0)
    sortedNums = sortedNums.sorted()
    var pastCalcs = [Int](repeating: 0, count: sortedNums.count)
    pastCalcs[0] = 1
    for (i, num) in sortedNums.enumerated() {
        for j in 0..<i {
            if (num - sortedNums[j]) <= 3 {
                pastCalcs[i] += pastCalcs[j]
            }
        }
    }
    return pastCalcs[sortedNums.count - 1]
}

let processedInput = processInput(input: input)
let part1 = calculateVoltage(input: processedInput)
print(findAllPerms(input: processedInput))
