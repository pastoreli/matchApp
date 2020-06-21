//
//  ViewController.swift
//  MatchApp
//
//  Created by Igor Pastoreli on 6/12/20.
//  Copyright © 2020 Igor Pastoreli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 0
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundMager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the view controller as the datasource and delegateof the colllection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        mounted()
        
    }
    
    func reload() {
        
        mounted()
        
        collectionView.reloadData()
    }
    
    func mounted () {
        cardsArray =  model.getCard()
        milliseconds = 60 * 1000
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
               
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    @objc func timerFired() {
        
        milliseconds -= 1
        
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        if(milliseconds == 0) {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            checkForGameEnd()
        }
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsArray[indexPath.row]
        
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
 
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == true && cell?.card?.isMatch == false {
            cell?.flipDown()
        } else {
            cell?.flipUp()
        }
        
        soundPlayer.playSound(effect: .flip)
        
        if firstFlippedCardIndex == nil {
            firstFlippedCardIndex = indexPath
        } else {
            checkForMatch(indexPath)
        }
        
    }
    
    // MSRK: Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        if(cardOne.id != cardTwo.id ) {
        
            if cardOne.imageName == cardTwo.imageName {
                cardOne.isMatch = true
                cardTwo.isMatch = true
                
                cardOneCell?.remove()
                cardTwoCell?.remove()
                
                soundPlayer.playSound(effect: .match)
                
                checkForGameEnd()
                
            } else {
                
                cardOne.isFlipped = false
                cardTwo.isFlipped = false
                
                cardOneCell?.flipDown()
                cardTwoCell?.flipDown()
                
                soundPlayer.playSound(effect: .nomatch)
            }
        }
        
        firstFlippedCardIndex = nil
    }

    func checkForGameEnd() {
        
        var hasWon = true
        
        for card in cardsArray {
            if(card.isMatch == false) {
                hasWon = false
                break
            }
        }
        
        if hasWon == true {
            showAlert(title: "Congratulations!", message: "You've won the game! ")
            timer?.invalidate()
        } else if(milliseconds <= 0) {
            showAlert(title: "Time's up", message: "Sorry, better luck next time!")
        }
        
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in self.reload() })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

