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
    func timesUp(with score: Int, of maxScore: Int)
    func gameCleared()
}

protocol GameLogicControllerType {
    var timer: Timer { get set }
    var duration: Int { get set }
    var guessedWords: [String] { get set }
    var wordQuiz: WordQuizType? { get set }
    var delegate: GameDelegate? { get set }
    var remainingWords: [String] { get set }
    
    func startTimer()
    func getTimer() -> String
    func checkGuessedWord(_ word: String) -> Bool
}


class GameLogicController: GameLogicControllerType {
    var duration = 300
    var timer = Timer()
    var wordQuiz: WordQuizType?
    var guessedWords: [String] = []
    var remainingWords: [String] = []
    weak var delegate: GameDelegate?
    
    static var shared = GameLogicController()
    
    // MARK: - Timer
    
    func startTimer() {
        DispatchQueue.global(qos: .userInteractive).async {
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updatedTimer), userInfo: nil, repeats: true)
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: RunLoop.Mode.default)
            runLoop.run()
        }
        
    }
    
    func getTimer() -> String {
        let min = (duration / 60) % 60
        let sec = duration % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
    func timesUp() {
        timer.invalidate()
        if let ans = wordQuiz?.answer {
            delegate?.timesUp(with: guessedWords.count, of: ans.count)
        }
    }
    
    @objc public func updatedTimer() {
        duration  = duration - 1
        DispatchQueue.main.async {
            
            self.delegate?.updateTimeLbl(with: self.getTimer())
            if self.duration == 0 {
                self.timesUp()
            }
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
    
    private func wordGuessed(_ word: String, at index: Int) {
        guessedWords.append(word)
        remainingWords.remove(at: index)
        
        if remainingWords.isEmpty == true {
            timer.invalidate()
            delegate?.gameCleared()
        }
    }
}
