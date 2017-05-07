//
//  Emissor.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/3/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class Emissor {
    var table = [Tag: Counter<Word>]()
    var words: Set<String> = []
    public private(set) var closed = false
    
    private(set) var singleTaggedWords = [Word: Tag]()
    
    func count(word: Word, withTag tag: Tag) {
        guard !closed else { return }
        
        if table[tag] == nil { table[tag] = Counter() }
        table[tag]?.add(element: word.lowercased())
        words.insert(word)
    }
    
    func count(pair: WordTagPair) { count(word: pair.word, withTag: pair.tag) }
    
    func probability(ofWord word: Word, fromTag tag: Tag) -> Double {
        return table[tag]?.probability(of: word.lowercased()) ?? 0
    }
    
    func logProbability(ofWord word: Word, fromTag tag: Tag) -> Double {
        return log(probability(ofWord: word, fromTag: tag))
    }
    
    func close() { closed = true }
}
