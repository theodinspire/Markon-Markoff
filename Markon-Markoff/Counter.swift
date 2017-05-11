//
//  Counter.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class Counter<T>: Sequence where T: Hashable {
    var counts = [T : Int]()
    var total = 0
    
    var length: Int { return counts.count }
    
    // Subscript!
    private(set) subscript(element: T) -> Int {
        get { return counts[element] ?? 0 }
        set {
            total += newValue - (counts[element] ?? 0)
            counts[element] = newValue
        }
    }
    
    // Add item to counter
    func add(element: T) { self[element] += 1 }
    
    func probability(of element: T) -> Double {
        return Double(self[element]) / Double(total)
    }
    
    func logProbability(of element: T) -> Double {
        return log(probability(of: element))
    }
    
    //
    func keysSorted() -> [T] {
        return counts.keys.sorted { self.counts[$0]! > self.counts[$1]! }
    }
    
    //  Sequence conformation
    func makeIterator() -> DictionaryIterator<T, Int> {
        return counts.makeIterator()
    }
}
