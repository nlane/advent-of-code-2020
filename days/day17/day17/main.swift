//
//  main.swift
//  day17
//
//  Created by Natalie Lane on 12/17/20.
//

import Foundation

func process(input: String, dim: Int) -> Set<[Int]> {
    let split = input.split(separator: "\n").map{ Array($0) }
    var points: Set<[Int]> = []
    for (x, row) in split.enumerated() {
        for (y, _) in row.enumerated() {
            if split[x][y] == "#" {
                if dim == 3 {
                    points.insert([x, y, 0])
                } else {
                    points.insert([x, y, 0, 0])
                }
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

// Given a point (w, x, y, z) calculate all 80 possible neighbors
func findNeighbors4d(point: [Int]) -> [ [Int] ] {
    let x = point[0], y = point[1], z = point[2], w = point[3]
    var neighbors: [ [Int] ] = []
    for xIdx in x-1...x+1 {
        for yIdx in y-1...y+1 {
            for zIdx in z-1...z+1 {
                for wIdx in w-1...w+1 {
                    if wIdx == w && xIdx == x && yIdx == y && zIdx == z { // given point, so skip
                        continue
                    } else {
                        neighbors.append([xIdx, yIdx, zIdx, wIdx])
                    }
                }
               
            }
        }
    }
    return neighbors
}

func calculateEmptyNeighbors(point: [ Int ], active: Set<[Int]>, dim: Int) -> Set<[Int]> {
    let neighbors = dim == 3 ? findNeighbors(point: point) : findNeighbors4d(point: point)
    var empty: Set<[Int]> = []
    for neighbor in neighbors {
        if !active.contains(neighbor) {
            empty.insert(neighbor)
        }
    }
    return empty
}

func calcAllEmpty(active: Set<[Int]>, dim: Int) -> Set<[Int]> {
    var empty: Set<[Int]> = []
    for cell in active {
        let emptyNeighbors = calculateEmptyNeighbors(point: cell, active: active, dim: dim)
        empty = empty.union(emptyNeighbors)
    }
    return empty
}

func calcNumActiveNeighbors(cell: [ Int ], active: Set<[Int]>, dim: Int) -> Int {
    let allNeighbors = dim == 3 ? findNeighbors(point: cell) : findNeighbors4d(point: cell)
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
// recalculate the inactive set
// repeat 6 times
func part1(starting: Set<[Int]>, dim: Int) -> Int {
    var active = starting
    var inactive = calcAllEmpty(active: active, dim: dim)
    for _ in 1...6 {
        var newActive: Set<[Int]> = []
        // for each active, calculate number of active neighbors. if == 2 || == 3 then remain active else inactive
        for cell in active {
            let activeNeighbors = calcNumActiveNeighbors(cell: cell, active: active, dim: dim)
            if activeNeighbors == 2 || activeNeighbors == 3 {
                newActive.insert(cell)
            }
        }
        // for each inactive, calculate number of active neighbors. if == 3 then active, else inactive
        for cell in inactive {
            let activeNeighbors = calcNumActiveNeighbors(cell: cell, active: active, dim: dim)
            if activeNeighbors == 3 {
                newActive.insert(cell)
            }
        }
        // Recalculate inactive with calcAllEmpty
        active = newActive
        inactive = calcAllEmpty(active: active, dim: dim)
    }
    return active.count
}

let startingPts = process(input: input, dim: 3)
print(part1(starting: startingPts, dim: 3))
let startingPts2 = process(input: input, dim: 4)
print(part1(starting: startingPts2, dim: 4))
