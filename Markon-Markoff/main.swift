//
//  main.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/2/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

let arguments = Arguments.process(CommandLine.arguments)

let (emissor, bigrams) = Trainer.train(from: arguments[.Train]!)

let viterbi = VitMostLikelyTagSmoothing(closingEmissor: emissor, andBigrams: bigrams)

switch arguments[.Operation]! {
case "test":
    Trainer.test(file: arguments[.Test]!, withModel: viterbi)
case "tag":
    Trainer.tag(file: arguments[.Test]!, usingModel: viterbi)
default:
    Arguments.printHelpAndExit()
}
