//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Igor Pastoreli on 6/12/20.
//  Copyright © 2020 Igor Pastoreli. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        self.card = card
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatch == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        
        backImageView.alpha = 1
        frontImageView.alpha = 1
        
        
        if card.isFlipped == true {
            flipUp(speed: 0)
        } else {
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUp(speed:TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
            
        }
        
        card?.isFlipped = false

    }
    
    func remove() {
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
