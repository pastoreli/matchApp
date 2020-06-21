//
//  SondManager.swift
//  MatchApp
//
//  Created by Igor Pastoreli on 6/21/20.
//  Copyright © 2020 Igor Pastoreli. All rights reserved.
//

import Foundation
import AVFoundation

class SoundMager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
        case .flip:
            soundFileName = "cardflip"
        
        case .match:
            soundFileName = "dingcorrect"
        
        case .nomatch:
            soundFileName = "dingwrong"
            
        case .shuffle:
            soundFileName = "shuffle"
            
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            
        } catch {
            
            print("Couldn't create an audio player")
            return
            
        }
    }
    
}
