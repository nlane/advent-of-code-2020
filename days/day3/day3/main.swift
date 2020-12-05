//
//  main.swift
//  day3
//
//  Created by Natalie Lane on 12/3/20.
//

import Foundation

//takes string input and converts it to a grid of individual strings
func processInput(input: String) -> [  [ String ] ] {
    let inputToArray = input.split(separator: "\n")
    var output: [ [String] ] = []
    for row in inputToArray {
        var rowArray: [String] = []
        for char in row {
            rowArray.append(String(char))
        }
        output.append(rowArray)
    }
    return output
}

// helper function to extend the map to the right
func addMapToRight(map: inout [ [ String ] ]){
    let newMap = processInput(input: input)
    for (index, _) in map.enumerated() {
        map[index].append(contentsOf: newMap[index])
    }
}

// returns the number of trees you run into aka "#"
func rideThatSlope(map: inout [ [ String ] ], rise: Int, run: Int) -> Int {
    var i = 0, j = 0, trees = 0
    while (i < map.count) {
        if (map[i][j] == "#") {
            trees += 1
        }
        i += rise
        j += run
        if j >= map[0].count {
            addMapToRight(map: &map)
        }
    }
    return trees
}


var map = processInput(input: input)

print(rideThatSlope(map: &map, rise: 1, run: 1) * rideThatSlope(map: &map, rise: 1, run: 3) * rideThatSlope(map: &map, rise: 1, run: 5) * rideThatSlope(map: &map, rise: 1, run: 7) * rideThatSlope(map: &map, rise: 2, run: 1))
