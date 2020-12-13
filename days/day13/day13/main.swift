//
//  main.swift
//  day13
//
//  Created by Natalie Lane on 12/13/20.
//

import Foundation

func process(input: String) -> (Int, [ Int ]) {
    let split = input.split(separator: "\n")
    var buses: [ Int ] = []
    for bus in split[1].split(separator: ",") {
        if bus != "x" {
            buses.append(Int(String(bus))!)
        }
    }
    return (Int(split[0])!, buses)
}

func processPt2(input: String) -> ( [ String ] ) {
    let split = input.split(separator: "\n")
    let output = split[1].components(separatedBy: ",")
    return output
}

func findNextBus(startTime: Int, buses: [ Int ]) -> Int {
    var currTime = startTime - 1
    var nextBus = 0
    while nextBus == 0 {
        currTime += 1
        for bus in buses.sorted() {
            if currTime % bus == 0 {
                nextBus = bus
                break
            }
        }
    }
    return (currTime - startTime) * nextBus
}

func calculateOffsets(buses: [ String ]) -> [ Int: Int ] {
    var offsets: [ Int: Int] = [:]
    for (idx, bus) in buses.enumerated() {
        if bus != "x" {
            offsets[Int(bus)!] = idx
        }
    }
    return offsets
}

func part2(buses: [ Int ], offsets: [ Int : Int ]) -> Int {
    var currTime = 100000000000000
    var step = 1
    for bus in buses {
        while ((currTime + offsets[bus]!) % bus != 0) {
            currTime += step
        }
        step *= bus
    }
    return currTime
}

let (startTime, activeBuses) = process(input: input)
print(findNextBus(startTime: startTime, buses: activeBuses))
let fullBuses = processPt2(input: input)
let offsets = calculateOffsets(buses: fullBuses)
print(part2(buses: activeBuses, offsets: offsets))
