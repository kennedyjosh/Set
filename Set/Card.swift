//
//  Card.swift
//  Concentration1
//
//  Created by Josh on 3/27/18.
//  Copyright © 2018 Josh Kennedy. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int { return identifier }
        
    private var identifier: Int    
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
