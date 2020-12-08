//
//  main.swift
//  day8
//
//  Created by Natalie Lane on 12/8/20.
//

import Foundation

func processInput(input: String) -> [ (String, Int) ] {
    let splitInput = input.split(separator: "\n")
    let output = splitInput.map{ (String($0.split(separator: " ")[0]), Int($0.split(separator: " ")[1])!) }
    return output
}

func runProgramPart1(instructions: [ (opcode: String, arg: Int) ]) -> Int {
    var accum = 0
    var idx = 0
    var visitedIndex: Set<Int> = []
    while !visitedIndex.contains(idx) {
        visitedIndex.insert(idx)
        let (currOp, currArg) = instructions[idx]
        switch currOp {
            case "nop":
                idx += 1
            case "jmp":
                idx += currArg
            case "acc":
                accum += currArg
                idx += 1
            default:
                return accum
            }
    }
    return accum
}

func getNextInstructions(instructions: [ (opcode: String, arg: Int) ], currIdx: Int) -> (Int, [ (opcode: String, arg: Int) ]) {
    // create a copy of the instructions
    var newInstructions = instructions
    var idx = currIdx + 1
    while (idx < instructions.count) {
        if instructions[idx].opcode == "jmp" {
            // replace this instruction in copy with nop and return
            newInstructions[idx].opcode = "nop"
            return (idx, newInstructions)
        } else if instructions[idx].opcode == "nop" {
            // replace this instruction in copy with "jmp" and return
            newInstructions[idx].opcode = "jmp"
            return (idx, newInstructions)
        } else {
            // move onto the next instruction
            idx += 1
        }
    }
    return (-1, [])
}

// run the instructions, return true if there is a loop, false if it terminates correctly
func doesProgramLoop(instructions: [ (opcode: String, arg: Int) ]) -> (Int, Bool) {
    var accum = 0
    var idx = 0
    var visitedIndex: Set<Int> = []
    while !visitedIndex.contains(idx) && idx < instructions.count {
        visitedIndex.insert(idx)
        let (currOp, currArg) = instructions[idx]
        switch currOp {
            case "nop":
                idx += 1
            case "jmp":
                idx += currArg
            case "acc":
                accum += currArg
                idx += 1
            default:
                return (accum, false)
            }
    }
    return (accum, visitedIndex.contains(idx))
}

func runProgramPart2(instructions: [ (opcode: String, arg: Int) ]) -> Int {
    var (idx, nextInstructions) = (-1, instructions)
    var (accum, doesLoop) = (0, true)
    while(doesLoop) {
        (idx, nextInstructions) = getNextInstructions(instructions: instructions, currIdx: idx)
        (accum, doesLoop) = doesProgramLoop(instructions: nextInstructions)
    }
    return accum
}

let instructions = processInput(input: input)
print(runProgramPart2(instructions: instructions))
