//
//  Set.swift
//  Set
//
//  Created by Josh on 4/5/18.
//  Copyright © 2018 Josh Kennedy. All rights reserved.
//

import Foundation

class Set {
    
    private(set) var deck = [Card]()
    private(set) var cardsDisplayed = [Card]()
    private(set) var cardsMatched = [Card]()
    private(set) var cardsSelected = [Card]()
    
    init() {
        // create a deck of 81 cards
        for _ in 1..<81 {
            deck += [Card()]
        }
        // deal 12 cards on to table
        for index in deck.startIndex..<12 {
            cardsDisplayed.append(deck.remove(at:index))
        }
    }
    
    func selectCard(at index: Int) {
        let card = cardsDisplayed[index]
        assert(cardsDisplayed.contains(card), "Cannot select a card that is not being displayed: \(card)")
        // if card is being displayed and it hasn't been matched
        cardsSelected.append(card)
    }
    
    func deselectCard(at index: Int) {
        let card = cardsDisplayed[index]
        assert(cardsSelected.contains(card), "Cannot deselct a card that has never been selected: \(card)")
        // if card is being displayed and it hasn't been matched
        cardsSelected.remove(at: cardsSelected.index(of: card)!)
    }
    
    func dealMoreCards() {
        // add 3 cards to cardsDisplayed and remove them from deck
        if !deck.isEmpty {
            for _ in 1...3 {
                cardsDisplayed.append(deck.remove(at: deck.startIndex))
            }
        }
    }
    
    func cardsMatch() -> Bool {
        return true
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
