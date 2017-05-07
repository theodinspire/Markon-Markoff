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
    
    var knownCount: Int { get }
    var knownCorrect: Int { get }
    var unknownCount: Int { get }
    var unknownCorrect: Int { get }
    
    init(closingEmissor emsr: Emissor, andBigrams bgrm: BigramDistribution)
    
    func getTagSequence(for pairs: [WordTagPair]) -> [Tag]
    func getTagSequence(for words: [Word]) -> [Tag]
}

extension Viterbi {
    var count: Int { return knownCount + unknownCount }
    var correct: Int { return knownCorrect + unknownCorrect }
}
