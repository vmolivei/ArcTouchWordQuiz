//
//  HomeViewModel.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol HomeViewModelType {
    var communicator: WordQuizCommunicatorType { get }
    var logicController: GameLogicControllerType { get set }
    var delegate: GameDelegate? { get set }
    
    //Data
    func fetchData(completion: @escaping ((Error?) -> Void))
    
    // Game Cycle
    func checkWord(_ word: String) -> Bool
    func startGame()
    func resetGame()
    
    // UI Helpers
    func getTitle() -> String?
    func getScore() -> String?
    func getTimer() -> String?
    func numberOfGuessedWords() -> Int
    func guessedWord(for index: IndexPath) -> String?
}

class HomeViewModel: HomeViewModelType {
    let communicator: WordQuizCommunicatorType
    var logicController: GameLogicControllerType
    
    weak var delegate: GameDelegate? {
        set {
            logicController.delegate = newValue
        }
        get{
            return logicController.delegate
        }
    }
    
    init(communicator: WordQuizCommunicatorType = WordQuizCommunicator.shared,
         logicController: GameLogicControllerType = GameLogicController.shared) {
        self.communicator = communicator
        self.logicController = logicController
    }
    
    // MARK: - Data loading
    
    func fetchData(completion: @escaping ((Error?) -> Void)) {
        communicator.fetchWordQuiz { [weak self] (quiz, error) in
            guard let self = self, let quiz = quiz, error == nil else {
                completion(NSError(domain: "Unknown", code: 504, userInfo: nil))
                return
            }
            
            self.logicController.wordQuiz = quiz
            self.resetGame()
            completion(nil)
        }
    }
    
    // MARK: - Helpers
    
    func getTitle() -> String? {
        return logicController.wordQuiz?.question
    }
    
    func getScore() -> String? {
        let guessedWords = logicController.guessedWords.count
        let totalWords = logicController.wordQuiz?.answer.count ?? 0
        return String(format: "%02i/%02i", guessedWords, totalWords)
    }
    
    func getTimer() -> String? {
        return logicController.getTimer()
    }
    
    func numberOfGuessedWords() -> Int {
        return logicController.guessedWords.count
    }
    
    func guessedWord(for index: IndexPath) -> String? {
        guard index.row < logicController.guessedWords.count else { return nil }
        return logicController.guessedWords[index.row]
    }
    
    // MARK: - Game Cycle
    
    func checkWord(_ word: String) -> Bool {
        return logicController.checkGuessedWord(word)
    }
    
    func startGame() {
        logicController.startTimer()
    }
    
    func resetGame() {
        guard let answer = logicController.wordQuiz?.answer else { return }
        logicController.duration = 300
        logicController.guessedWords = []
        logicController.remainingWords = answer
        logicController.timer.invalidate()
    }
}
