//
//  BigramPair.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

struct BigramIterator: IteratorProtocol {
    var prev = (word: "<s>", tag: "<s>")
    var sentenceIterator: IndexingIterator<[WordTagPair]>
    
    init(sentence: [WordTagPair]) {
        sentenceIterator = sentence.makeIterator()
    }
    
    mutating func next() -> (first: WordTagPair, Second: WordTagPair)? {
        guard prev.tag != "</s>" else { return nil }
        
        let first = prev
        let second = sentenceIterator.next() ?? ("</s>", "</s>")
        prev = second
        
        return (first, second)
    }
}
