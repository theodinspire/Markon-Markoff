//
//  Trainer.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/7/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class Trainer {
    private init() { }
    
    static func train(from filename: String) -> (Emissor, BigramDistribution) {
        print("Training...")
        
        guard let stream = StreamReader(path: filename) else {
            print("\(filename) does not exist")
            exit(EXIT_FAILURE)
        }
        let builder = TaggedSentenceBuilder(withReader: stream)
        
        let emissor = Emissor()
        let bigrams = BigramDistribution()
        
        for sentence in builder {
            for (one, two) in sentence.pairs {
                emissor.count(pair: two)
                bigrams.count(first: one.tag, second: two.tag)
            }
        }
        
        return (emissor, bigrams)
    }
    
    static func test(file filename: String, withModel viterbi: Viterbi) {
        print("Testing...")
        
        guard let testStream = StreamReader(path: arguments[.Test]!) else { exit(EXIT_FAILURE) }
        let testBuilder = TaggedSentenceBuilder(withReader: testStream)
        
        guard let output = StreamWriter(destinationFile: arguments[.Output]!) else { exit(EXIT_FAILURE) }
        
        var sentences = [[WordTagPair]]()
        var predictedTags = [[Tag]]()
        
        for testSentence in testBuilder {
            sentences.append(testSentence)
            predictedTags.append(viterbi.getTagSequence(for: testSentence))
        }
        
        let cnt = viterbi.count
        let crct = viterbi.correct
        let knCnt = viterbi.knownCount
        let knCrct = viterbi.knownCorrect
        let uknCnt = viterbi.unknownCount
        let uknCrct = viterbi.unknownCorrect
        
        let p100 = 100 * Double(crct) / Double(cnt)
        let k100 = 100 * Double(knCrct) / Double(knCnt)
        let u100 = 100 * Double(uknCrct) / Double(uknCnt)
        
        let pAcrcy = String(format: "Accuracy: %7u / %-7u : %2.2f%%", crct, cnt, p100)
        let kAcrcy = String(format: "   Known: %7u / %-7u : %2.2f%%", knCrct, knCnt, k100)
        let uAcrcy = String(format: " Unknown: %7u / %-7u : %2.2f%%", uknCrct, uknCnt, u100)
        
        print(pAcrcy)
        print(kAcrcy)
        print(uAcrcy)
        
        output.write(line: pAcrcy)
        output.write(line: kAcrcy)
        output.write(line: uAcrcy)
        output.write(line: "")
        
        let longPad: (String) -> String = { $0.padding(toLength: 20, withPad: " ", startingAt: 0) }
        let shortPad: (String) -> String = { $0.padding(toLength: 4, withPad: " ", startingAt: 0) }
        
        output.write(line: "\(longPad("TOKEN")) \(shortPad("TAG")) \(shortPad("MDL"))")
        output.write(line: "")
        
        for (i, sentence) in sentences.enumerated() {
            let prediction = predictedTags[i]
            
            for (j, pair) in sentence.enumerated() {
                let word = longPad(pair.word)
                let tag = shortPad(pair.tag)
                let mdl = shortPad(prediction[j])
                
                output.write(line: "\(word) \(tag) \(mdl)")
            }
            
            output.write(line: "")
        }
        
        output.close()
    }
    
    static func tag(file filename: String, usingModel viterbi: Viterbi) {
        print("Tagging...")
        
        guard let testStream = StreamReader(path: arguments[.Test]!) else { exit(EXIT_FAILURE) }
        let testBuilder = SentenceBuilder(withReader: testStream)
        
        guard let output = StreamWriter(destinationFile: arguments[.Output]!) else { exit(EXIT_FAILURE) }
        
        var sentences = [[Word]]()
        var predictedTags = [[Tag]]()
        
        for testSentence in testBuilder {
            sentences.append(testSentence)
            predictedTags.append(viterbi.getTagSequence(for: testSentence))
        }
        
        let longPad: (String) -> String = { $0.padding(toLength: 20, withPad: " ", startingAt: 0) }
        let shortPad: (String) -> String = { $0.padding(toLength: 4, withPad: " ", startingAt: 0) }
        
        output.write(line: "\(longPad("TOKEN")) \(shortPad("MDL"))")
        output.write(line: "")
        
        for (i, sentence) in sentences.enumerated() {
            let prediction = predictedTags[i]
            
            for (j, word) in sentence.enumerated() {
                let word = longPad(word)
                let mdl = shortPad(prediction[j])
                
                output.write(line: "\(word) \(mdl)")
            }
            
            output.write(line: "")
        }
        
        output.close()
    }
}
