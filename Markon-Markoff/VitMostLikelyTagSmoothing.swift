//
//  VitMostLikelyTagSmoothing.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/6/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class VitMostLikelyTagSmoothing: Viterbi {
    let emissor: Emissor
    let bigrams: BigramDistribution
    
    init(closingEmissor emsr: Emissor, andBigrams bgrm: BigramDistribution) {
        emissor = emsr
        bigrams = bgrm
        
        emissor.close()
        bigrams.close()
    }
    
    func getTagSequenceWithMostLikelyTagForUnkowns(for words: [Word]) -> [Tag] {
        let sentence = words + [Tag.sentenceEnd]
        
        var backPointersList = [[Tag: Tag]]()
        var prevProbabilities = [Tag.sentenceStart: 0.0]  //  Log Probability ln(1) = 0
        
        let tags = Set(emissor.table.keys)
        let openClassTags = Set(tags.filter { !Tag.assumedClosed.contains($0) })
        
        for word in sentence {
            var backPointers = [Tag: Tag]()
            var probabilities = [Tag: Double]()
            
            for tag in tags {
                let emission = emissor.logProbability(ofWord: word, fromTag: tag)
                guard emission != -Double.infinity else { continue }
                
                var maxProbability = -Double.infinity
                var backPointer: Tag? = nil
                
                for previous in prevProbabilities.keys {
                    let candidateProbability = bigrams.logProbability(ofNextTag: tag, givenPrevious: previous) + prevProbabilities[previous]!
                    //  If previous weren't a key in prevProbabilities,
                    //  we wouldn't be in this loop
                    if candidateProbability > maxProbability {
                        maxProbability = candidateProbability
                        backPointer = previous
                    }
                }
                
                guard maxProbability != -Double.infinity else { continue }
                
                probabilities[tag] = emission + maxProbability
                //  addition as they are logProbabilities
                backPointers[tag] = backPointer!
                //  Can explicitly unwrap as it would be assigned if maxPro is non-infinite
            }
            
            if probabilities.isEmpty {
                for tag in openClassTags {
                    let emission = 0.0
                    
                    var maxProbability = -Double.infinity
                    var backPointer: Tag? = nil
                    
                    for previous in prevProbabilities.keys {
                        let candidateProbability = bigrams.logProbability(ofNextTag: tag, givenPrevious: previous) + prevProbabilities[previous]!
                        //  If previous weren't a key in prevProbabilities,
                        //  we wouldn't be in this loop
                        if candidateProbability > maxProbability {
                            maxProbability = candidateProbability
                            backPointer = previous
                        }
                    }
                    
                    guard maxProbability != -Double.infinity else { continue }
                    
                    probabilities[tag] = emission + maxProbability
                    //  addition as they are logProbabilities
                    backPointers[tag] = backPointer!
                    //  Can explicitly unwrap as it would be assigned if maxPro is non-infinite
                }
            }
            
            backPointersList.append(backPointers)
            prevProbabilities = probabilities
        }
        
        var tagsReversed = [Tag]()
        
        var lastTag: Tag
        
        if backPointersList.last!.keys.contains(Tag.sentenceEnd) {
            lastTag = Tag.sentenceEnd
        } else {
            var maxProb = -Double.infinity
            var maxTag: Tag? = nil
            
            for (tag, prob) in prevProbabilities {
                if prob > maxProb {
                    maxProb = prob
                    maxTag = tag
                }
            }
            
            lastTag = maxTag!
        }
        
        for backPointers in backPointersList.reversed() {
            lastTag = backPointers[lastTag]!
            tagsReversed.append(lastTag)
        }
        
        tagsReversed.removeLast()   //  Remove sentence start
        return tagsReversed.reversed()
    }
    
    func getTagSequenceWithMostLikelyTagForUnkowns(for pairs: [WordTagPair]) -> [Tag] {
        let words = pairs.map() { $0.word }
        return getTagSequenceWithMostLikelyTagForUnkowns(for: words)
    }
}
