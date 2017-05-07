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
    var forewardTable = [Tag: Counter<Tag>]()
    var backwardTable = [Tag: Counter<Tag>]()
    
    private(set) var closed = false
    
    func count(first: Tag, second: Tag) {
        guard !closed else { return }
        
        if forewardTable[first] == nil { forewardTable[first] = Counter() }
        forewardTable[first]?.add(element: second)
        if backwardTable[second] == nil { backwardTable[second] = Counter() }
        backwardTable[second]?.add(element: first)
    }
    
    func count(pair: (first: WordTagPair, second: WordTagPair)) {
        count(first: pair.first.tag, second: pair.second.tag)
    }
    
    func probability(ofNextTag next: Tag, givenPrevious prev: Tag) -> Double {
        return forewardTable[prev]?.probability(of: next) ?? 0
    }
    
    func probability(ofPreviousTag prev: Tag, givenNext next: Tag) -> Double {
        return backwardTable[next]?.probability(of: prev) ?? 0
    }
    
    func logProbability(ofNextTag next: Tag, givenPrevious prev: Tag) -> Double {
        return log(probability(ofNextTag: next, givenPrevious: prev))
    }
    
    func logProbability(ofPreviousTag prev: Tag, givenNext next: Tag) -> Double {
        return backwardTable[next]?.probability(of: prev) ?? 0
    }
    
    func close() { closed = true }
}
