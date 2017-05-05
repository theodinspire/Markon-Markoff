//
//  BigramSequence.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class BigramSequence: Sequence {
    fileprivate let array: [WordTagPair]
    fileprivate init(_ ary: [WordTagPair]) { array = ary }
    internal func makeIterator() -> BigramIterator {
        return BigramIterator(sentence: array)
    }
}

extension Array where Element == WordTagPair {
    var pairs: BigramSequence {
        return BigramSequence(self)
    }
}
