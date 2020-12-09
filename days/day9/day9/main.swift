//
//  main.swift
//  day9
//
//  Created by Natalie Lane on 12/9/20.
//

import Foundation

func processInput(input: String) -> [ Int ] {
    return input.split(separator: "\n").map{ Int($0)! }
}

func processPreamble(input: [ Int ] ) -> [ Int : [ Int ] ] {
    var sums: [Int: [Int]] = [:]
    for idx in 0...23 {
        var localSum: [Int] = []
        for inner in (idx + 1)...24 {
            localSum.append(input[idx] + input[inner])
        }
        sums[idx] = localSum
    }
    return sums
}

func sumInSearch(search: [ Int : [ Int ] ], sum: Int) -> Bool {
    for searchSum in search.values.joined() {
        if sum == searchSum {
            return true
        }
    }
    return false
}

func findFaultyNumber(input: [ Int ]) -> Int {
    var sums = processPreamble(input: input)
    for idx in 25..<input.count {
        if !sumInSearch(search: sums, sum: input[idx]) {
            return input[idx]
        }
        // remove the 24 elements of sums that are now outside of the search window
        sums.removeValue(forKey: idx-25)
        // calculate the next 24 sums using our latest addition to the search window: input[idx]
        for i in (idx-24)..<idx {
            if sums[i] == nil {
                sums[i] = []
            }
            sums[i] = sums[i]! + [(input[idx] + input[i])]
        }
    }
    return -1
}

func findSubSequence(input: [ Int ], goalSum: Int) -> (Int, Int) {
    for i in 0..<input.count {
        let startIdx = i
        var localSum = 0
        for j in i..<input.count {
            if (localSum + input[j]) == goalSum {
                return (startIdx, j)
            } else if (localSum + input[j]) < goalSum {
                localSum += input[j]
            } else {
                break
            }
        }
    }
    return (-1, -1)
}

func findMinAndMax(input: [Int]) -> Int {
    var min = input[0]
    var max = input[0]
    for num in input {
        if num > max {
            max = num
        }
        if num < min {
            min = num
        }
    }
    return min + max
}

let nums = processInput(input: input)
let faultyNum = findFaultyNumber(input: nums)

let (startIdx, endIdx) = findSubSequence(input: nums, goalSum: faultyNum)
print(findMinAndMax(input: Array(nums[startIdx...endIdx])))
