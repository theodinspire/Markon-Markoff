//
//  SentenceBuilder.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

typealias Word = String
typealias Tag = String
typealias WordTagPair = (word: Word, tag: Tag)

class SentenceBuilder: Sequence {
    let reader: StreamReader
    
    init(withReader rdr: StreamReader, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        reader = rdr
    }
    
    convenience init?(fromFile filepath: String, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        guard let rdr = StreamReader(path: filepath) else { return nil }
        self.init(withReader: rdr)
    }
    
    func nextSentence() -> [WordTagPair]? {
        var sentence = [(Word, Tag)]()
        
        var line: String? = reader.nextLine()
        guard line != nil else { return nil }
        
        while line != "" && line != nil {
            let bits = line!.components(separatedBy: " ")
            guard bits.count >= 2 else { line = reader.nextLine(); break }
            sentence.append(bits[0], bits[1])
            line = reader.nextLine()
        }
        
        return sentence
    }
    
    //  Sequence
    func makeIterator() -> AnyIterator<[WordTagPair]> {
        return AnyIterator {
            return self.nextSentence()
        }
    }
}
