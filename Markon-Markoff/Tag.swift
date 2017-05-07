//
//  Tag.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/5/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

typealias Tag = String

extension Tag {
    static let sentenceStart = "<s>"
    static let sentenceEnd = "</s>"
    
    static let assumedClosed: Set = ["<s>", "</s>", "CC", "DT", "EX",
                                     "MD", "POS", "PRP", "PRP$", "TO",
                                     "WDT", "WP", "WP$", "WRB"]
}
