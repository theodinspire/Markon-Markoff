//
//  Bigram.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class BigramDistribution {
    //let counter = Counter<Tag>()
    var table = [Tag: Counter<Tag>]()
    
    private(set) var closed = false
    
    func count(first: Tag, second: Tag) {
        guard !closed else { return }
        
        if table[first] == nil { table[first] = Counter() }
        table[first]?.add(element: second)
    }
    
    func count(pair: (first: WordTagPair, second: WordTagPair)) {
        count(first: pair.first.tag, second: pair.second.tag)
    }
    
    func close() { closed = true }
}
