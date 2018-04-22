//
//  ViewController.swift
//  Set
//
//  Created by Josh on 4/5/18.
//  Copyright © 2018 Josh Kennedy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        for button in otherButtons+cardButtons {
            button.layer.cornerRadius = 8.0
            button.titleLabel?.textAlignment = NSTextAlignment.center
        }
        updateViewFromModel()
    }
    
    private var game = Set()
    
    private var cardDesign = [Card: NSAttributedString]()
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private var otherButtons: [UIButton]!
    
    @IBOutlet private weak var dealMoreCardsButton: UIButton!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        let cardDisplayedIndex = cardButtons.index(of: sender)!
        // if card touched is being displayed, select it
        if cardDisplayedIndex < game.cardsDisplayed.count {
            if game.cardsSelected.index(of: game.cardsDisplayed[cardDisplayedIndex]) == nil {
                game.selectCard(at: cardDisplayedIndex)
                print("Card selected: \(game.cardsDisplayed[cardDisplayedIndex].hashValue)")
            } else {
                game.deselectCard(at: cardDisplayedIndex)
            }
            updateViewFromModel()
        }
    }
    
    @IBAction private func dealMoreCards(_ sender: UIButton) {
        game.dealMoreCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        // draw cards that should be displayed
        for index in game.cardsDisplayed.indices {
            let button = cardButtons[index]
            let card = game.cardsDisplayed[index]
            
            // draw card text and background color
            button.setAttributedTitle(getCardText(of: card, on: button), for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            
            // select or deselct cards (visually) as needed
            if game.cardsSelected.count == 3 && game.cardsSelected.contains(card) {
                if game.cardsMatch() {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                } else {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else {
                // if there are more than 3 cards now selected, remove all except the most
                // recently selected one
                if game.cardsSelected.count > 3 {
                    for _ in 0...2 {
                        let cardToBeRemovedIndex = game.cardsDisplayed.index(of: game.cardsSelected[0])
                        game.deselectCard(at: cardToBeRemovedIndex!)
                    }
                }
                // visually select card, if appropriate
                if game.cardsSelected.contains(card) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                } else {
                    button.layer.borderWidth = 0
                }
            }
        }
        // make cards that shouldnt be displayed invisible
        for index in game.cardsDisplayed.endIndex..<cardButtons.count {
            let button = cardButtons[index]
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
        // enable or disable "deal 3 more cards" button
        if game.cardsDisplayed.count > 23 || game.deck.count == 0 {
            dealMoreCardsButton.isEnabled = false
            dealMoreCardsButton.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: UIControlState.normal)
        } else {
            dealMoreCardsButton.isEnabled = true
            dealMoreCardsButton.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
        }
    }

private func getCardText(of card: Card, on button: UIButton) -> NSAttributedString {
    // choose random card color, design, and (number of) shapes
    while cardDesign[card] == nil {
        let shape = ["▲","▲ ▲","▲ ▲ ▲","●","● ●","● ● ●", "■", "■ ■","■ ■ ■"].random()
        let color = [UIColor.blue, UIColor.black, UIColor.red].random()
        let design = ["striped","solid","outlined"].random()
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeColor: color,
            .foregroundColor : design != "striped" ? color.withAlphaComponent(1.0) : color.withAlphaComponent(0.3),
            .strokeWidth : design != "outlined" ? -1.0 : 7.0
        ]
        let attributedString = NSAttributedString(string: shape, attributes: attributes)
        cardDesign[card] = cardDesign.index(where: { $0.value == attributedString } ) == nil ? attributedString : nil
    }
    return cardDesign[card] ?? NSAttributedString(string: "?")
}





}

//////////////////////////////////////////////////////////////////////////////////////

extension Collection {
    // returns a random element from within the collection
    func random() -> Element {
        assert(!isEmpty, "\(self).random() : collection must not be empty to call method random()")
        return self[self.index(self.startIndex, offsetBy: count.arc4random)]    }
}
