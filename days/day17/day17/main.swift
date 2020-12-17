//
//  main.swift
//  day17
//
//  Created by Natalie Lane on 12/17/20.
//

import Foundation

func process(input: String) -> Set<[Int]> {
    let split = input.split(separator: "\n").map{ Array($0) }
    var points: Set<[Int]> = []
    for (x, row) in split.enumerated() {
        for (y, _) in row.enumerated() {
            if split[x][y] == "#" {
                points.insert([x, y, 0])
            }
        }
    }
    return points
}

// Given a point (x, y, z) calculate all 26 possible neighbors
func findNeighbors(point: [Int]) -> [ [Int] ] {
    let x = point[0], y = point[1], z = point[2]
    var neighbors: [ [Int] ] = []
    for xIdx in x-1...x+1 {
        for yIdx in y-1...y+1 {
            for zIdx in z-1...z+1 {
                if xIdx == x && yIdx == y && zIdx == z { // given point, so skip
                    continue
                } else {
                    neighbors.append([xIdx, yIdx, zIdx])
                }
            }
        }
    }
    return neighbors
}

func calculateEmptyNeighbors(point: [ Int ], active: Set<[Int]>) -> Set<[Int]> {
    let neighbors = findNeighbors(point: point)
    var empty: Set<[Int]> = []
    for neighbor in neighbors {
        if !active.contains(neighbor) {
            empty.insert(neighbor)
        }
    }
    return empty
}

func calcAllEmpty(active: Set<[Int]>) -> Set<[Int]> {
    var empty: Set<[Int]> = []
    for cell in active {
        let emptyNeighbors = calculateEmptyNeighbors(point: cell, active: active)
        empty = empty.union(emptyNeighbors)
    }
    return empty
}

func calcNumActiveNeighbors(cell: [ Int ], active: Set<[Int]>) -> Int {
    let allNeighbors = findNeighbors(point: cell)
    var total = 0
    for neighbor in allNeighbors {
        if active.contains(neighbor) {
            total += 1
        }
    }
    return total
}

// Given a starting set of points, calculate the empty spaces between and around them and store that
// Go through both sets and calculate the updated positions
// recalculate the two sets
// repeat 6 times
func part1(starting: Set<[Int]>) -> Int {
    var active = starting
    var inactive = calcAllEmpty(active: active)
    for _ in 1...6 {
        var newActive: Set<[Int]> = []
        // for each active, calculate number of active neighbors. if == 2 || == 3 then remain active else inactive
        for cell in active {
            let activeNeighbors = calcNumActiveNeighbors(cell: cell, active: active)
            if activeNeighbors == 2 || activeNeighbors == 3 {
                newActive.insert(cell)
            }
        }
        // for each inactive, calculate number of active neighbors. if == 3 then active, else inactive
        for cell in inactive {
            let activeNeighbors = calcNumActiveNeighbors(cell: cell, active: active)
            if activeNeighbors == 3 {
                newActive.insert(cell)
            }
        }
        // Recalculate inactive with calcAllEmpty
        active = newActive
        inactive = calcAllEmpty(active: active)
    }
    return active.count
}

let startingPts = process(input: input)
print(part1(starting: startingPts))
