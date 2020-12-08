//
//  main.swift
//  day7
//
//  Created by Natalie Lane on 12/7/20.
//

import Foundation

func processInput(input: String) -> [ String : [ (Int, String) ] ] {
    // convert to array of strings at \n
    let rules = input.split(separator: "\n")
    // set-up output
    var processedRules: [ String : [ (Int, String) ] ] = [:]
    // for each rule in the input, convert it into a usable string
    for rule in rules {
        // split the outer bag from the inner bags
        let outerBag = rule.components(separatedBy: " bags")[0]
        var innerBagsStr = String(rule.suffix(rule.count - outerBag.count))
    
        // clean the innerBag string (there has got to be a cleaner way to do this...)
        let innerBagsSplit = innerBagsStr.components(separatedBy: " bags contain ")
        innerBagsStr = innerBagsSplit[1]
        innerBagsStr = innerBagsStr.replacingOccurrences(of: "s.", with: "")
        innerBagsStr = innerBagsStr.replacingOccurrences(of: "s, ", with: "")
        innerBagsStr = innerBagsStr.replacingOccurrences(of: ", ", with: "")
        innerBagsStr = innerBagsStr.replacingOccurrences(of: ".", with: "")
        innerBagsStr = innerBagsStr.replacingOccurrences(of: " bags", with: "+")
        innerBagsStr = innerBagsStr.replacingOccurrences(of: " bag", with: "+")
        let allInnerBags = innerBagsStr.split(separator: "+")
        
        var bags: [ (Int, String) ] = []
        
        //make each inner bag a tuple by splitting the number and the name
        for bag in allInnerBags {
            if bag != "no other" {
                bags.append(( Int(bag.prefix(1))!, String(bag.suffix(bag.count - 2))))
            }
        }
        
        // push the array of tuples onto the output under the outer bag's key
        processedRules[outerBag] = bags
    }
    return processedRules
}

// for each rule, see if the bag is contained inside of an outer bag
// if it is, then find all outer bags that contain that bag (recursive step)
// keep track of visited bags so you don't double count
// at the end, your set of visited rules is the total number of bags
func sumAllAllowedBags(rules: [ String : [ (Int, String) ] ], bag: String, visited: inout Set<String> ) -> Int {
    for rule in rules {
        for innerBag in rule.value {
            if innerBag.1 == bag && !visited.contains(rule.key){
                visited.insert(rule.key)
                sumAllAllowedBags(rules: rules, bag: rule.key, visited: &visited)
            }
        }
    }
    return visited.count
}

// starting with the rule for your given bag
// look at each inner bag needed for that one
// calculate the sum of the bags needed to fill each of those inner bags (recursive step)
// sum all of this up and return the total
func sumAllSubBags(rules: [ String : [ (Int, String) ] ], bag: String) -> Int {
    let innerBags = rules[bag]
    var count = 0
    for (num, bagName) in innerBags! {
        let subBagCount = sumAllSubBags(rules: rules, bag: bagName)
        count += num + num * subBagCount
    }
    return count
}

let rules = processInput(input: input)
var visited: Set<String> = []
print(sumAllAllowedBags(rules: rules, bag: "shiny gold", visited: &visited))
print(sumAllSubBags(rules: rules, bag: "shiny gold"))
