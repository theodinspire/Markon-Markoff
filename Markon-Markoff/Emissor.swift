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
    public private(set) var closed = false
    
    func count(word: Word, withTag tag: Tag) {
        guard !closed else { return }
        
        if table[tag] == nil { table[tag] = Counter() }
        table[tag]?.add(element: word.lowercased())
    }
    
    func count(pair: WordTagPair) { count(word: pair.word, withTag: pair.tag) }
    
    func close() { closed = true }
}
