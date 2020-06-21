//
//  CardModel.swift
//  MatchApp
//
//  Created by Igor Pastoreli on 6/12/20.
//  Copyright © 2020 Igor Pastoreli. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCard() -> [Card] {
        
        var generatedNumbers = [Int]()
        
        var generatedCards = [Card]()
        
        while generatedNumbers.count < 8  {
            let randomNumber = Int.random(in: 1...13)
            
            if(generatedNumbers.contains(randomNumber) == false) {
            
                let cardOne = Card()
                let cardTwo = Card()
                
                cardOne.id = "card-\(generatedNumbers.count)"
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.id = "card2-\(generatedNumbers.count)"
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCards += [ cardOne, cardTwo ]
                
                generatedNumbers.append(randomNumber)
                
                print("n: \(randomNumber)")
            }
        }
        
        generatedCards.shuffle()
        
        return generatedCards
    }
    
}
