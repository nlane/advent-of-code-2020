//
//  main.swift
//  day11
//
//  Created by Natalie Lane on 12/11/20.
//

import Foundation

func processInput(input: String) -> [ [ Character ] ] {
    let splitInput = input.components(separatedBy: "\n")
    var output: [ [ Character ] ] = []
    for line in splitInput {
        let newLine = Array(line)
        output.append(newLine)
        
    }
    return output
}

func isOccupied(i: Int, j: Int, grid: [ [ Character ] ]) -> Bool {
    let iBound = grid.count
    let jBound = grid[0].count
    if i < 0 || i >= iBound || j < 0 || j >= jBound {
        return false
    } else {
        return grid[i][j] == "#"
    }
}

func countOccupiedNeighbors(i: Int, j: Int, grid: [ [ Character ] ]) -> Int {
    var occupied = 0
    for x in -1...1 {
        for y in -1...1 {
            if x == y && x == 0 {
                continue
            } else {
                if isOccupied(i: x + i, j: y + j, grid: grid) {
                    occupied += 1
                }
            }
        }
    }
    return occupied
}

// This should be refactored but I'm tired and I want my stars so this will be the day 11 pt 2 approach
func countOccupiedPt2(i: Int, j: Int, grid: [ [ Character ] ]) -> Int {
    var occupied = 0
    // check left
    var left = j - 1
    while(left >= 0) {
        if grid[i][left] != "." {
            if isOccupied(i: i, j: left, grid: grid) {
                occupied += 1
            }
            break
        }
        left -= 1
    }
    // check left-up
    left = j - 1
    var up = i - 1
    while (left >= 0 && up >= 0) {
        if grid[up][left] != "." {
            if isOccupied(i: up, j: left, grid: grid) {
                occupied += 1
            }
            break
        }
        left -= 1
        up -= 1
    }
    
    // check up
    up = i - 1
    while (up >= 0) {
        if grid[up][j] != "." {
            if isOccupied(i: up, j: j, grid: grid) {
                occupied += 1
            }
            break
        }
        up -= 1
    }
    
    // check up-right
    var right = j + 1
    up = i - 1
    while (up >= 0 && right < grid[0].count) {
        if grid[up][right] != "." {
            if isOccupied(i: up, j: right, grid: grid) {
                occupied += 1
            }
            break
        }
        right += 1
        up -= 1
    }
    
    // check right
    right = j + 1
    while (right < grid[0].count) {
        if grid[i][right] != "." {
            if isOccupied(i: i, j: right, grid: grid) {
                occupied += 1
            }
            break
        }
        right += 1
    }
    
    // check down-right
    var down = i + 1
    right = j + 1
    while (down < grid.count && right < grid[0].count) {
        if grid[down][right] != "." {
            if isOccupied(i: down, j: right, grid: grid) {
                occupied += 1
            }
            break
        }
        right += 1
        down += 1
    }
    
    // check down
    down = i + 1
    while (down < grid.count) {
        if grid[down][j] != "." {
            if isOccupied(i: down, j: j, grid: grid) {
                occupied += 1
            }
            break
        }
        down += 1
    }
    
    // check down left
    down = i + 1
    left = j - 1
    while (down < grid.count && left >= 0) {
        if grid[down][left] != "." {
            if isOccupied(i: down, j: left, grid: grid) {
                occupied += 1
            }
            break
        }
        down += 1
        left -= 1
    }
    return occupied
}

func tickGrid(grid: [ [Character] ], tolerance: Int) -> [ [Character] ] {
    var newGrid = grid
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            if grid[i][j] == "." {
                continue
            }
            // occupied = count neighbors occupied
            // CHANGE BELOW LINE FOR PT 1
            let occupied = countOccupiedPt2(i: i, j: j, grid: grid)
            // if seat is empty and occupied = 0 -> Mark to switch to occupied
            if grid[i][j] == "L" && occupied == 0 {
                newGrid[i][j] = "#"
            }
            // if seat is occupied and occupied >=4 -> Mark to switch to empty
            if grid[i][j] == "#" && occupied >= tolerance {
                newGrid[i][j] = "L"
            }
        }
    }
    return newGrid
}


func totalOccupiedSeats(grid: [ [ Character ] ]) -> Int {
    var count = 0
    for i in 0..<grid.count {
        for j in 0..<grid[0].count {
            if isOccupied(i: i, j: j, grid: grid) {
                count += 1
            }
        }
    }
    return count
}

func runChaos(grid: [ [ Character] ]) -> Int {
    var prevGrid = grid
    var currGrid = tickGrid(grid: prevGrid, tolerance: 5)
    while (prevGrid != currGrid) {
        prevGrid = currGrid
        currGrid = tickGrid(grid: prevGrid, tolerance: 5)
    }
    return totalOccupiedSeats(grid: currGrid)
}


let grid = processInput(input: input)
print(runChaos(grid: grid))
