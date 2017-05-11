//
//  Bigram.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class BigramDistribution {
    let counter = Counter<Tag>()
    var forewardTable = [Tag: Counter<Tag>]()
    //var backwardTable = [Tag: Counter<Tag>]()
    
    private(set) var closed = false
    
    var count: Int {
        var count = 0
        for (_, counter) in forewardTable { count += counter.length }
        return count
    }
    
    func count(first: Tag, second: Tag) {
        guard !closed else { return }
        
        if forewardTable[first] == nil { forewardTable[first] = Counter() }
        forewardTable[first]?.add(element: second)
//        if backwardTable[second] == nil { backwardTable[second] = Counter() }
//        backwardTable[second]?.add(element: first)
    }
    
    func count(pair: (first: WordTagPair, second: WordTagPair)) {
        count(first: pair.first.tag, second: pair.second.tag)
    }
    
    func probability(ofNextTag next: Tag, givenPrevious prev: Tag) -> Double {
        return forewardTable[prev]?.probability(of: next) ?? 0
    }
    
//    func probability(ofPreviousTag prev: Tag, givenNext next: Tag) -> Double {
//        return backwardTable[next]?.probability(of: prev) ?? 0
//    }
    
    func logProbability(ofNextTag next: Tag, givenPrevious prev: Tag) -> Double {
        return log(probability(ofNextTag: next, givenPrevious: prev))
    }
    
//    func logProbability(ofPreviousTag prev: Tag, givenNext next: Tag) -> Double {
//        return backwardTable[next]?.probability(of: prev) ?? 0
//    }
    
    func close() { closed = true }
    
    func makeUnigramCountFile(toFile filename: String, withHeader header: String? = nil) {        guard let output = StreamWriter(destinationFile: filename) else { return }
        
        if let head = header {
            output.write(line: head)
            output.writeBlankLine()
        }
        
        for (tag, count) in counter {
            output.write(line: "\(shortPad(tag)) : \(count)")
        }
        
        output.close()
    }
    
    func makeBigramCountFile(toFile filename: String, withHeader header: String? = nil) {
        guard let output = StreamWriter(destinationFile: filename) else { return }
        
        if let head = header {
            output.write(line: head)
            output.writeBlankLine()
        }
        
        
        for (first, counter) in forewardTable {
            for (second, count) in counter {
                output.write(line: "\(shortPad(first)) → \(shortPad(second)) : \(count)")
            }
        }
        output.close()
    }
}
