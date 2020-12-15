//
//  main.swift
//  day15
//
//  Created by Natalie Lane on 12/15/20.
//

import Foundation

let input = "15,5,1,4,7,0"

func process(input: String) -> [ Int ] {
    let split = input.components(separatedBy: ",")
    return split.map { Int($0)! }
}

func playStartingNums(starting: [Int]) -> [Int: Int] {
    var numToTurn: [Int: Int] = [:]
    for (idx, num) in starting.enumerated() {
        numToTurn[num] = idx + 1
    }
    return numToTurn
}

func playGame(input: [ Int ]) -> Int {
    var pastTurns = playStartingNums(starting: input)
    var currNum = input.last!
    var newNum = true
    var prevTurn = 0
    for turn in pastTurns.count+1...2020 {
        if newNum {
            currNum = 0
            newNum = false
        } else {
            currNum = turn - 1 - prevTurn
        }
        if pastTurns[currNum] != nil {
            prevTurn = pastTurns[currNum]!
        } else {
            newNum = true
        }
        pastTurns[currNum] = turn
    }
    return currNum
}

let intInput = process(input: input)
let test = process(input: "0,3,6")
print(playGame(input: intInput))

