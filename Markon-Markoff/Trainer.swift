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
        
        var sentenceCount = 0
        var tokenCount = 0
        
        for sentence in builder {
            for (one, two) in sentence.pairs {
                emissor.count(pair: two)
                bigrams.count(first: one.tag, second: two.tag)
                
                tokenCount += 1
            }
            
            sentenceCount += 1
        }
        
        var header = "* Training data:\n"
        header += "- # of training sentences = \(sentenceCount)\n"
        header += "- # of POS tags (including STOP's) = \(tokenCount)\n"
        header += "- # of unique bigrams = \(bigrams.count)\n"
        header += "- # of word tokens = \(tokenCount - sentenceCount)\n"
        header += "- # of unique words (vocabulary) = \(emissor.words.count)"
        
        let emissionFile = prefix(filename: filename, with: "tagEmissions")
        let unigramFile = prefix(filename: filename, with: "tagUnigrams")
        let bigramFile = prefix(filename: filename, with: "tagBigrams")
        
        emissor.makeCountFile(toFile: emissionFile, withHeader: header)
        bigrams.makeUnigramCountFile(toFile: unigramFile, withHeader: header)
        bigrams.makeBigramCountFile(toFile: bigramFile, withHeader: header)
        
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
