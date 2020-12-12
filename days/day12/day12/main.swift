//
//  main.swift
//  day12
//
//  Created by Natalie Lane on 12/12/20.
//

import Foundation

func process(input: String) -> [ (Character, Int) ] {
    let splitInput = input.split(separator: "\n").map { (navigation: Substring) -> (Character, Int) in
        let dir = navigation.prefix(1)
        let idx = navigation.index(after: navigation.startIndex)
        let steps = navigation.suffix(from: idx)
        let tuple = (Character(String(dir)), Int(steps)!)
        return tuple
    }
    return splitInput
}

func navigate(dir: Character, north: inout Int, east: inout Int, steps: Int) -> (Int, Int) {
    switch dir {
    case "N":
        north += steps
    case "S":
        north -= steps
    case "E":
        east += steps
    case "W":
        east -= steps
    default:
        return (0, 0)
    }
    return (north, east)
}

func followNavigation(directions: [ ( Character, Int ) ] ) -> Int {
    let fourDirs: [Character] = ["E", "S", "W", "N"]
    var north = 0, east = 0
    var currDir: Character = "E"
    for (dir, steps) in directions {
        if fourDirs.contains(dir) { // Direct navigation to N S E or W
            (north, east) = navigate(dir: dir, north: &north, east: &east, steps: steps)
        } else if dir == "R" || dir == "L" { // Rotate
            var idx = steps / 90 // Get number of rotations
            if dir == "R" { // if right then add the rotations
                idx = idx + fourDirs.firstIndex(of: currDir)!
                idx = idx >= 4 ? idx - 4 : idx // adjust idx if out of bounds
            } else { // if left then subtract the rotations
                idx = fourDirs.firstIndex(of: currDir)! - idx
                idx = idx < 0 ? idx + 4 : idx // adjust idx if out of bounds
            }
            currDir = fourDirs[idx]
        } else { // Forward direction
            (north, east) = navigate(dir: currDir, north: &north, east: &east, steps: steps)
        }
    }
    return abs(north) + abs(east)
}

let directions = process(input: input)
print(followNavigation(directions: directions))
