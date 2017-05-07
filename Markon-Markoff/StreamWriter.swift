//
//  StreamWriter.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/6/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class StreamWriter {
    var fileHandle: FileHandle!
    let encoding: String.Encoding
    
    init?(destinationFile path: String, encoding: String.Encoding = .utf8) {
        do {
            let url = URL(fileURLWithPath: path)
            let parentDirectory = url.appendingPathComponent("../")
            
            try FileManager.default.createDirectory(at: parentDirectory, withIntermediateDirectories: true, attributes: nil)
            FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
            
            fileHandle = FileHandle(forWritingAtPath: path)
            self.encoding = encoding
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    deinit { self.close() }

    func write(line: String) {
        guard let data = (line + "\n").data(using: encoding) else { return }
        fileHandle.write(data)
    }
    
    func close() { fileHandle.closeFile() }
}
