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
var set: Set<String> = []
var sentenceCount = 0
var wordCount = 0

for sentence in builder {
    sentenceCount += 1
    wordCount += sentence.count
    for (one, two) in sentence.pairs {
        emissor.count(pair: two)
        bigrams.count(first: one.tag, second: two.tag)
        set.insert(two.word)
    }
}

emissor.close()
bigrams.close()

var bigramCount = 0

for (_, two) in bigrams.table { bigramCount += two.counts.count }

print("Number of sentences: \(sentenceCount)")
print("Number of words: \(wordCount)")
print("Total number of bigrams: \(bigramCount)")
print("Total unique words: \(set.count)")
