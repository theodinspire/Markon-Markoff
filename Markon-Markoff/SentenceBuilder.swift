//
//  SentenceBuilder.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/7/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class SentenceBuilder: Sequence {
    let reader: StreamReader
    
    init(withReader rdr: StreamReader, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        reader = rdr
    }
    
    convenience init?(fromFile filepath: String, delimiter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        guard let rdr = StreamReader(path: filepath) else { return nil }
        self.init(withReader: rdr)
    }
    
    func nextSentence() -> [Word]? {
        var sentence = [Word]()
        
        var line: String? = reader.nextLine()
        guard line != nil else { return nil }
        
        while line != "" && line != nil {
            let bits = line!.components(separatedBy: " ")
            guard bits.count >= 1 else { line = reader.nextLine(); break }
            sentence.append(bits[0])
            line = reader.nextLine()
        }
        
        return sentence
    }
    
    //func rewind() { reader.rewind() }
    
    //  Sequence
    func makeIterator() -> AnyIterator<[Tag]> {
        return AnyIterator {
            return self.nextSentence()
        }
    }
}
