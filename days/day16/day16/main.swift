//
//  main.swift
//  day16
//
//  Created by Natalie Lane on 12/16/20.
//

import Foundation

func process(input: String) -> ([String: [ClosedRange<Int>] ], [Int], [ [Int] ]) {
    let threeParts = input.components(separatedBy: "\n\n")
    let rules = threeParts[0].split(separator: "\n")
    let myTicket = threeParts[1].split(separator: "\n")
    var fullTickets = threeParts[2].split(separator: "\n")
    fullTickets.remove(at: 0)
    var ruleRanges: [String: [ClosedRange<Int>] ] = [:]
    for rule in rules {
        let label = String(rule.split(separator: ":")[0])
        let fullRanges = rule.components(separatedBy: ": ").last!
        let splitRanges = fullRanges.components(separatedBy: " or ")
        var twoRanges: [ClosedRange<Int>] = []
        for range in splitRanges {
            let startAndStop = range.split(separator: "-").map { Int($0)! }
            twoRanges.append(startAndStop[0]...startAndStop[1])
        }
        ruleRanges[label] = twoRanges
    }
    let finalTicket = myTicket[1].split(separator: ",").map { Int($0)! }
    var otherTickets: [ [ Int ] ] = []
    for ticket in fullTickets {
        otherTickets.append(ticket.split(separator: ",").map { Int($0)! })
    }
    return (ruleRanges, finalTicket, otherTickets)
}

func part1(rules: [ String: [ ClosedRange<Int> ] ], otherTickets: [ [Int] ]) -> Int {
    var sum = 0
    for ticket in otherTickets {
        for val in ticket {
            var valid = false
            for ranges in rules.values {
                for range in ranges {
                    if range.contains(val) {
                        valid = true
                    }
                }
            }
            sum = valid ? sum : sum + val
        }
    }
    return sum
}


let (rules, myTicket, otherTickets) = process(input: input)
print(part1(rules: rules, otherTickets: otherTickets))
