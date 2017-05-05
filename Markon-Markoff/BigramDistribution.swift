//
//  Bigram.swift
//  Markon-Markoff
//
//  Created by Eric Cormack on 5/4/17.
//  Copyright © 2017 the Odin Spire. All rights reserved.
//

import Foundation

class Bigram {
    let counter = Counter<Tag>()
    let map = [Tag: Counter<Tag>]()
}
