//
//  main.swift
//  day5
//
//  Created by Natalie Lane on 12/5/20.
//

import Foundation


func processInput(input: String) -> [ (String, String) ] {
    let seats = input.split(separator: "\n")
    let final = seats.map {
        (String($0.prefix(7)), String($0.suffix(3)))
    }
    return final
}

func getRow(rowSequence: String) -> Int {
    var min = 0, max = 127
    for direction in rowSequence {
        if direction == "F" {
            max = (max + min) / 2
        } else {
            min = ((max + min) / 2) + 1
        }
    }
    return min
}

func getCol(colSequence: String) -> Int {
    var min = 0, max = 7
    for direction in colSequence {
        if direction == "L" {
            max = (max + min) / 2
        } else {
            min = ((max + min) / 2) + 1
        }
    }
    return min
}

func calculateSeats(seats: [ (rowSeq: String, colSeq: String) ]) -> (Int, [Int]) {
    var highest = 0
    var allSeats: [Int] = []
    for seat in seats {
        let row = getRow(rowSequence: seat.rowSeq)
        let col = getCol(colSequence: seat.colSeq)
        let seatVal = row * 8 + col
        allSeats.append(seatVal )
        highest = seatVal > highest ? seatVal : highest
    }
    return (highest, allSeats)
}

func findMySeat(seats: [ Int ]) -> Int {
    // seat numbers go from 0 to 1023
    var missingSeats = Set(0..<1023)
    var confirmedSeats: Set<Int> = []
    for seat in seats {
        missingSeats.remove(seat)
        confirmedSeats.insert(seat)
    }
    for seat in missingSeats {
        if confirmedSeats.contains(seat + 1) && confirmedSeats.contains(seat - 1) {
            return seat
        }
    }
    return 0
}


let seats = processInput(input: input)
let (highestSeat, allSeats) = calculateSeats(seats: seats)
print(findMySeat(seats: allSeats))
