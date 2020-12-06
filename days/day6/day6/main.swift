//
//  main.swift
//  day6
//
//  Created by Natalie Lane on 12/6/20.
//

import Foundation


func processInput(input: String) -> [ (Int, String) ] {
    let condensed = input.components(separatedBy: "\n\n")
    var inputWithCount: [ (Int, String) ] = []
    for group in condensed {
        let splitAtNewLine = group.split(separator: "\n")
        let tuple = (splitAtNewLine.count, group.replacingOccurrences(of: "\n", with: ""))
        inputWithCount.append(tuple)
    }
    return inputWithCount
}

func countUniqueLetters(strSeq: String) -> Int {
    var unique: Set<Character> = []
    for char in strSeq {
        unique.insert(char)
    }
    return unique.count
}

func sumAllAnswers(answers: [ (count: Int, seq: String) ] ) -> Int {
    var sum = 0
    for answer in answers {
        sum += countUniqueLetters(strSeq: answer.seq)
    }
    return sum
}

func countAllYesQuestions( countSeq: (count: Int, seq: String) ) -> Int {
    var letterToCount: [Character: Int] = [:]
    var total = 0
    for letter in countSeq.seq {
        if letterToCount.contains(where: {$0.key == letter}) {
            letterToCount[letter]! += 1
        } else {
            letterToCount[letter] = 1
        }
        if letterToCount[letter]! == countSeq.count {
            total += 1
        }
    }
    return total
}

func sumAllYesQuestions(answers: [ (count: Int, seq: String) ] ) -> Int {
    var sum = 0
    for answer in answers {
        sum += countAllYesQuestions(countSeq: answer)
    }
    return sum
}

let answers = processInput(input: input)
print(sumAllYesQuestions(answers: answers))
