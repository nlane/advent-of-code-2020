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

func getNewDir(currDir: Character, clockwise: Bool, degrees: Int) -> Character {
    let fourDirs: [Character] = ["E", "S", "W", "N"]
    var idx = degrees
    if clockwise {
        idx = idx + fourDirs.firstIndex(of: currDir)!
        idx = idx >= 4 ? idx - 4 : idx
    } else {
        idx = fourDirs.firstIndex(of: currDir)! - idx
        idx = idx < 0 ? idx + 4 : idx
    }
    return fourDirs[idx]
}

func followNavigationPt2(directions: [ (Character, Int) ]) -> Int {
    var boatN = 0, boatE = 0
    var waypoint: [ (dir: Character, steps: Int) ] = [ ("N", 1), ("E", 10) ]
    for (dir, steps) in directions {
        if ["E", "S", "W", "N"].contains(dir) { // move waypoint
            var newSteps = steps
            if waypoint[0].dir == "S" && (dir == "N" || dir == "S") {
                newSteps = -steps
            } else if waypoint[1].dir == "W" && (dir == "E" || dir == "W") {
                newSteps = -steps
            }
            var nSteps = waypoint[0].steps
            var eSteps = waypoint[1].steps
            (nSteps, eSteps) = navigate(dir: dir, north: &nSteps, east: &eSteps, steps: newSteps)
            waypoint = [ (waypoint[0].dir, nSteps), (waypoint[1].dir, eSteps)]
        } else if dir == "R" || dir == "L" { // rotate waypoint
            let degrees = steps / 90
            let newDirOne = getNewDir(currDir: waypoint[0].dir, clockwise: dir == "R", degrees: degrees)
            let newDirTwo = getNewDir(currDir: waypoint[1].dir, clockwise: dir == "R", degrees: degrees)
            if newDirOne == "N" || newDirOne == "S" {
                waypoint = [ (newDirOne, waypoint[0].steps), (newDirTwo, waypoint[1].steps) ]
            } else {
                waypoint = [ (newDirTwo, waypoint[1].steps), (newDirOne, waypoint[0].steps) ]
            }
        } else { // move ship to waypoint, move waypoint out
            for _ in 1...steps {
                (boatN, boatE) = navigate(dir: waypoint[0].dir, north: &boatN, east: &boatE, steps: waypoint[0].steps)
                (boatN, boatE) = navigate(dir: waypoint[1].dir, north: &boatN, east: &boatE, steps: waypoint[1].steps)
            }
        }
    }
    return abs(boatN) + abs(boatE)
}

let directions = process(input: input)
print(followNavigation(directions: directions))
print(followNavigationPt2(directions: directions))
