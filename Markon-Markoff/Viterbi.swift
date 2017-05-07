//
//  Viterbi.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/5/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

protocol Viterbi {
    var emissor: Emissor { get }
    var bigrams: BigramDistribution { get }
}
