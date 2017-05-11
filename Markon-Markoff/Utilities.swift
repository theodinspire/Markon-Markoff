//
//  Utilities.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/7/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

// Padding functions
func longPad(_ str: String) -> String {
    return str.padding(toLength: 20, withPad: " ", startingAt: 0)
}

func shortPad(_ str: String) -> String {
    return str.padding(toLength: 4, withPad: " ", startingAt: 0)
}

// Prefix file name
func prefix(filename: String, with prefix: String) -> String {
    let origin = URL(fileURLWithPath: filename)
    
    return origin.deletingLastPathComponent().relativeString + prefix + "-" + origin.lastPathComponent
}
