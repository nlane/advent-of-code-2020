//
//  main.swift
//  day1
//
//  Created by Natalie Lane on 12/1/20.
//

import Foundation

// Read in input
func readInput() -> [Int] {
  let strings = input.split(separator: "\n")
  return strings.map { Int($0) ?? 0 }
}


// part 1 (two sum)
func twoSum(numbers: [Int]) -> (Int, Set<Int>) {
  var reference : Set<Int> = []
  var multiplied : Int = 0
  for val in numbers {
    let remainder = 2020 - val
    if reference.contains(remainder) {
      multiplied = remainder * val
    } else {
      reference.insert(val)
    }
  }
  return (multiplied, reference)
}

// part 2 (three sum)
func threeSum(numbers: [Int], reference: Set<Int>) -> Int {
  for (i, numi) in numbers.enumerated() {
    for (j, numj) in numbers.enumerated() {
      if i == j {
        break
      }
      let remainder = 2020 - numi - numj
      if remainder < 2020 && reference.contains(remainder) {
        return remainder * numi * numj
      }
    }
  }
  return 0
}

let numbers = readInput()
let (answer, setRef) = twoSum(numbers: numbers)
let part2 = threeSum(numbers: numbers, reference: setRef)
print(part2)
