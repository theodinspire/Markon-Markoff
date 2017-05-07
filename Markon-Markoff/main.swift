//
//  main.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

guard let stream = StreamReader(path: "WSJ-train.txt") else { exit(EXIT_FAILURE) }
let builder = SentenceBuilder(withReader: stream)

let emissor = Emissor()
let bigrams = BigramDistribution()

for sentence in builder {
    for (one, two) in sentence.pairs {
        emissor.count(pair: two)
        bigrams.count(first: one.tag, second: two.tag)
    }
}

let viterbi = Viterbi(closingEmissor: emissor, andBigrams: bigrams)

guard let testStream = StreamReader(path: "WSJ-test.txt") else { exit(EXIT_FAILURE) }
let testBuilder = SentenceBuilder(withReader: testStream)

guard let output = StreamWriter(destinationFile: "output-WSJ-test.txt") else { exit(EXIT_FAILURE) }

var wordCount = 0
var correct = 0

for testSentence in testBuilder {
    let predictedTags = viterbi.getTagSequenceWithMostLikelyTagForUnkowns(for: testSentence)
    
    for (i, pair) in testSentence.enumerated() {
        output.write(line: "\(pair.word) \(pair.tag) \(predictedTags[i])")
        wordCount += 1
        correct += pair.tag == predictedTags[i] ? 1 : 0
    }
    
    output.write(line: "")
}

let percent = 100.0 * Double(correct) / Double(wordCount)
print(percent)

output.close()
