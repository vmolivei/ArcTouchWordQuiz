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
    var wordQuiz: WordQuiz? { get set }
    func fetchData(completion: @escaping ((Error?) -> Void))
    func getTitle() -> String?
    func getScore() -> String?
    func resetGame()
}

class HomeViewModel: HomeViewModelType {
    let communicator: WordQuizCommunicatorType
    var wordQuiz: WordQuiz?
    var guessedWords: [String] = []
    var timer = Timer()
    
    init(communicator: WordQuizCommunicatorType = WordQuizCommunicator.shared) {
        self.communicator = communicator
    }
    
    func fetchData(completion: @escaping ((Error?) -> Void)) {
        
    }
    
    func getTitle() -> String? {
        return wordQuiz?.question
    }
    
    func getScore() -> String? {
        return "\(wordQuiz?.answer.count ?? 0)"
    }
    
    func numberOfGuessedWords() -> Int {
        return guessedWords.count
    }
    
    func guessedWord(for index: IndexPath) -> String {
        return guessedWords[index.row]
    }
    
    func resetGame() {
    }
}
