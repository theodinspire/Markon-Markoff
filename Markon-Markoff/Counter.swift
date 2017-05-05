//
//  Counter.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class Counter<T> where T: Hashable {
    var counts = [T : Int]()
    var total = 0
    
    // Add item to counter
    func add(element: T) {
        total += 1
        guard let count = counts[element] else {
            counts[element] = 1
            return
        }
        counts[element] = count + 1
    }
}
