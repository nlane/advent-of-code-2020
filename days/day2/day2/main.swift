//
//  main.swift
//  day2
//
//  Created by Natalie Lane on 12/2/20.
//

import Foundation

// convert string input to array of substrings
func processInput() -> [Substring] {
    return input.split(separator: "\n")
}

// take a substring formatted like "1-3 a: aabbic" and split it up into individual variables
func passwordToParts(password: Substring) -> (Int, Int, String, String) {
    let parsedPword = password.split(separator: " ")
    let minMax = parsedPword[0].split(separator: "-")
    let letter = parsedPword[1].prefix(1)
    return (Int(minMax[0])!, Int(minMax[1])!, String(letter), String(parsedPword[2]))
}

// original check password function, it interprets the first two numbers of the password string to be a min and max count for the letter
func checkPassword(password: Substring) -> Bool {
    let (min, max, letter, pword) = passwordToParts(password: password)
    let letterCount = pword.reduce(0) {
        if String($1) == letter {
            return $0 + 1
        }
        return $0
    }
    return min <= letterCount && letterCount <= max
}

// part 2 check password function, it interprets the first two numbers of the password string to be indexes representing locations for the letter
func checkPasswordPt2(password: Substring) -> Bool {
    let (idx1, idx2, letter, pword) = passwordToParts(password: password)
    let total = pword.enumerated().reduce(0, { reducer, tuple in
        // if we are looking at the right letter and the letter is in one of the two indexes, let's mark it as seen
        if String(tuple.element) == letter && (tuple.offset + 1 == idx1 || tuple.offset + 1 == idx2){
            return reducer + 1
        }
        return reducer
    })
    return total == 1
}

// takes in an array of password strings and an authenticator function and returns the number of passwords that adhere to that password protocol
func getNumberValid(passwords: [Substring], authenticator: (Substring) -> Bool) -> Int {
    var count = 0
    for pword in passwords {
        if (authenticator(pword)) {
            count += 1
        }
    }
    return count
}

let passwords = processInput()

print(getNumberValid(passwords: passwords, authenticator: checkPassword))

print(getNumberValid(passwords: passwords, authenticator: checkPasswordPt2))
