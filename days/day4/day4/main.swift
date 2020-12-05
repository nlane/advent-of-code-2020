//
//  main.swift
//  day4
//
//  Created by Natalie Lane on 12/4/20.
//

import Foundation

func processInput(input: String) -> [ [ String: String ] ] {
    let result = input.split(separator: "\n", omittingEmptySubsequences: false)
    var final: [ [ String: String ] ] = []
    var current: [ String: String ] = [:]
    for str in result {
        let pairs = str.split(separator: " ")
        if pairs == [] {
            final.append(current)
            current = [:]
        } else {
            for pair in pairs {
                let keyVal = pair.split(separator: ":")
                current[String(keyVal[0])] = String(keyVal[1])
            }
        }
    }
    final.append(current)
    return final
}

func checkValidPassport(passport: [ String: String ]) -> Bool {
    if passport.count == 8 {
        return true
    } else if passport.count == 7 && !passport.contains(where: { $0.key == "cid" } ) {
        return true
    } else {
        return false
    }
}

func checkHeight(height: String) -> Bool {
    let num = height.prefix(height.count - 2)
    if height.hasSuffix("cm") {
        return (num >= "150" && num <= "193")
    } else if height.hasSuffix("in") {
        return (num >= "59" && num <= "76")
    } else {
        return false
    }
}

func checkHairColor(color: String) -> Bool {
    let charSet: Set = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" ]
    if !color.hasPrefix("#") {
        return false
    } else {
        for c in color.suffix(6) {
            if !charSet.contains(String(c)) {
                return false
            }
        }
    }
    return color.count == 7
}

func checkFields(passport: [ String: String ]) -> Bool {
    let eyes: Set = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    return (passport["byr"]! <= "2002" && passport["byr"]! >= "1920")
    && (passport["iyr"]! <= "2020" && passport["iyr"]! >= "2010")
    && (passport["eyr"]! <= "2030" && passport["eyr"]! >= "2020")
        && (passport["pid"]!.count == 9)
        && (eyes.contains(passport["ecl"]!))
    && (checkHeight(height: passport["hgt"]!))
    && (checkHairColor(color: passport["hcl"]!))
}


func checkAllPassports(passports: [ [ String: String ] ]) -> Int {
    var count = 0
    for p in passports {
        if checkValidPassport(passport: p) && checkFields(passport: p) {
            count += 1
        }
    }
    return count
}

let passports = processInput(input: input)
print(checkAllPassports(passports: passports))
