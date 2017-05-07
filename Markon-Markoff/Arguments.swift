//
//  Arguments.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/7/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class Arguments {
    private init() { }
    
    static func process(_ arguments: [String]) -> [ArgumentTags: String]{
        guard let trainIndex = arguments.index(of: "-train") else { printHelpAndExit() }
        guard trainIndex + 1 < arguments.count else { printHelpAndExit() }
        guard let testIndex = arguments.index(of: "-test") else { printHelpAndExit() }
        guard testIndex + 1 < arguments.count else { printHelpAndExit() }
        
        let train = arguments[trainIndex + 1]
        let test = arguments[testIndex + 1]
        
        let testURL = URL(fileURLWithPath: test)
        let testDir = testURL.deletingLastPathComponent().relativeString
        let testFile = testURL.lastPathComponent
        let output = testDir + "output-" + testFile
        
        return [.Train: train, .Test: test, .Output: output]
    }
    
    static func printHelpAndExit() -> Never {
        print("Usage: markon-markoff -train [training file] -test [test-file]")
        print("Output file will be in the same directory as the test file")
        print("    with \"output\" prefixed to the test file name")
        
        exit(EXIT_SUCCESS)
    }
}

enum ArgumentTags {
    case Train, Test, Output
}
