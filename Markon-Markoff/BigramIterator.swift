//
//  BigramPair.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

struct BigramPair: IteratorProtocol {
    let prev = (word: "<s>", tag: "<s>")
    let sentence: [WordTagPair]
    
    mutating func next() -> (first: WordTagPair, Second: WordTagPair)? {
    }
}
