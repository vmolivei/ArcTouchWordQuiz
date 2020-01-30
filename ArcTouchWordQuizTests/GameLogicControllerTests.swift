//
//  GameLogicControllerTests.swift
//  ArcTouchWordQuizTests
//
//  Created by Victor on 1/30/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import XCTest
@testable import ArcTouchWordQuiz

class GameLogicControllerTests: XCTestCase {
    var logicCtrl: GameLogicController!
    var delegate: MockGameDelegate!
    
    override func setUp() {
        delegate = MockGameDelegate()
        logicCtrl = GameLogicController()
        logicCtrl?.delegate = delegate
        
        logicCtrl.wordQuiz = WordQuiz(question: "Test", answer: ["123", "456"])
    }

    override func tearDown() {
        delegate = nil
        logicCtrl = nil
    }
    
    func test_getTimer_HasCorretStringFormat() {
        logicCtrl.duration = 300
        let str = logicCtrl.getTimer()
        XCTAssertEqual(str, "05:00")
    }
    
    func test_timesUp_CallsDelegate() {
        logicCtrl.timesUp()
        XCTAssertTrue(delegate.timesUpCalled)
    }
    
    func test_checkGuessedWord_ReturnTrueWhenHasWord() {
        logicCtrl.remainingWords = ["123", "456"]
        let hasWord = logicCtrl.checkGuessedWord("123")
        let noWord = logicCtrl.checkGuessedWord("321")
        XCTAssertTrue(hasWord)
        XCTAssertFalse(noWord)
    }
    
    func test_checkGuessedWord_FoundFinalWord_CallsGameClearedDelegate() {
        logicCtrl.remainingWords = ["123"]
        let hasWord = logicCtrl.checkGuessedWord("123")
        XCTAssertTrue(hasWord)
        XCTAssertTrue(delegate.gameClearedCalled)
    }
}

class MockGameLogicController: GameLogicControllerType {
    var timer: Timer = Timer()
    var duration: Int = 300
    var guessedWords: [String] = []
    var wordQuiz: WordQuizType?
    var delegate: GameDelegate?
    var remainingWords: [String] = []
    var timerStarted = false
    var foundWord = false
    
    func startTimer() {
        timerStarted = true
    }
    
    func getTimer() -> String {
        return "timer"
    }
    
    func checkGuessedWord(_ word: String) -> Bool {
        return foundWord
    }
}

class MockGameDelegate: GameDelegate {
    var updateTimeCalled = false
    var timesUpCalled = false
    var gameClearedCalled = false
    
    func updateTimeLbl(with value: String) {
        updateTimeCalled = true
    }
    
    func timesUp(with score: Int, of maxScore: Int) {
        timesUpCalled = true
    }
    
    func gameCleared() {
        gameClearedCalled = true
    }
}
