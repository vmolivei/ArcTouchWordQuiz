//
//  TimerLogicController.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func updateTimeLbl(with value: String)
    func timesUp()
    func gameCleared()
}

class GameLogicController {
    var duration = 300
    var timer = Timer()
    var wordQuiz: WordQuizType?
    var guessedWords: [String] = []
    var remainingWords: [String] = []
    weak var delegate: GameDelegate?
    
    static var shared = GameLogicController()
    
    // MARK: - Timer
    
    func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatedTimer), userInfo: nil, repeats: true)
    }
    
    func getTimer() -> String {
        let min = (duration / 60) % 60
        let sec = duration % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
    func timesUp() {
        timer.invalidate()
        delegate?.timesUp()
    }
    
    @objc func updatedTimer() {
        duration  = duration - 1
        delegate?.updateTimeLbl(with: getTimer())
        if duration == 0 {
            timesUp()
        }
    }
    
    // MARK: - Game Cylce
    
    func checkGuessedWord(_ word: String) -> Bool {
        for it in 0..<remainingWords.count {
            if remainingWords[it].lowercased() == word.lowercased() {
                wordGuessed(remainingWords[it], at: it)
                return true
            }
        }
        
        return false
    }
    
    func wordGuessed(_ word: String, at index: Int) {
        guessedWords.append(word)
        remainingWords.remove(at: index)
        
        if remainingWords.isEmpty == true {
            delegate?.gameCleared()
        }
    }
}
