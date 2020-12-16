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

func isValid(ticket: [ Int ], rules: [ String: [ClosedRange<Int>] ] ) -> Bool {
    for val in ticket {
        var isValValid = false
        for ranges in rules.values {
            for range in ranges {
                if range.contains(val) {
                    isValValid = true
                    break
                }
            }
            if isValValid { break }
        }
        if !isValValid { return false }
    }
    return true
}

func valFollowsRule(val: Int, rule: [ClosedRange<Int>]) -> Bool {
    return rule[0].contains(val) || rule[1].contains(val)
}

// for each column in the tickets, check to see if all columns comply with a rule.
func findColAndRule(rules: [ String: [ClosedRange<Int>]], tickets: [ [Int] ]) -> (String, Int) {
    for i in 0..<tickets[0].count { // for each ticket column
        var countPossible = 0 // count the number of possible rules the column could fit
        var lastPossibleRule = ""
        for rule in rules { // for each rule
            var rulePossible = true // assume the rule works for all tickets of this column
            for j in 0..<tickets.count { // for each ticket
                if !valFollowsRule(val: tickets[j][i], rule: rule.value) {
                    rulePossible = false
                    break
                }
            }
            if rulePossible {
                countPossible += 1
                lastPossibleRule = rule.key
            }
        }
        if countPossible == 1 { // if the column can only fit one rule, then we found it
            return (lastPossibleRule, i)
        }
    }
    return ("NONE", -1)
}

func getAllDepatureCols(fields: [ String: Int]) -> [Int] {
    var cols: [Int] = []
    for key in fields.keys {
        if key.contains("departure") {
            cols.append(fields[key]!)
        }
    }
    return cols
}

// find the columns one by one from process of elimation
// once you have all the fields mapped to their columns, extract out the columns only for "departure"
// multiply the values found in my ticket at those columns
func part2(rules: [ String: [ClosedRange<Int>]], tickets: [ [Int] ], myTicket: [Int]) -> Int {
    var elimateRules = rules
    var ruleToCol: [String: Int] = [:]
    while elimateRules.count != 0 {
        let (rule, col) = findColAndRule(rules: elimateRules, tickets: tickets)
        ruleToCol[rule] = col
        elimateRules.removeValue(forKey: rule)
    }
    let depCols = getAllDepatureCols(fields: ruleToCol)
    var final = 1
    for col in depCols {
        final *= myTicket[col]
    }
    return final
}

let (rules, myTicket, otherTickets) = process(input: input)
print(part1(rules: rules, otherTickets: otherTickets))
let filteredTix = otherTickets.filter { isValid(ticket: $0, rules: rules) }
print(part2(rules: rules, tickets: filteredTix, myTicket: myTicket))
