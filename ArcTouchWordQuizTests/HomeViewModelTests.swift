//
//  HomeViewModelTests.swift
//  ArcTouchWordQuizTests
//
//  Created by Victor on 1/30/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import XCTest
@testable import ArcTouchWordQuiz

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel?
    var mockCommunicator: MockWordQuizCommunicator!
    var mockGameLogicCtrl: MockGameLogicController!
    
    override func setUp() {
        mockCommunicator = MockWordQuizCommunicator()
        mockGameLogicCtrl = MockGameLogicController()
        viewModel = HomeViewModel(communicator: mockCommunicator,
                                  logicController: mockGameLogicCtrl)
    }

    override func tearDown() {
        viewModel = nil
        mockCommunicator = nil
        mockGameLogicCtrl = nil
    }
    
    func test_fetchData_ValidData_NoError() {
        let expect = expectation(description: "Test valid Data")
        mockCommunicator.error = nil
        mockCommunicator.quiz = WordQuiz(question: "Test", answer: ["Right"])
        
        viewModel?.fetchData(completion: { (error) in
            XCTAssertNil(error)
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fetchData_InvalidData_Error() {
        let expect = expectation(description: "Test valid Data")
        mockCommunicator.error = .badData(NSError(domain: "Test", code: 123, userInfo: nil))
        mockCommunicator.quiz = WordQuiz(question: "Test", answer: ["Right"])
        
        viewModel?.fetchData(completion: { (err) in
            XCTAssertNotNil(err)
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_startGame_ValidateTimer() {
        mockGameLogicCtrl.timer.invalidate()
        viewModel?.startGame()
        XCTAssertTrue(mockGameLogicCtrl.timerStarted)
    }
    
    func test_resetGame_CleanLogicCtrl() {
        mockGameLogicCtrl.wordQuiz = WordQuiz(question: "Test", answer: ["test", "1234"])
        mockGameLogicCtrl.duration = 10
        mockGameLogicCtrl.guessedWords = ["123"]
        mockGameLogicCtrl.remainingWords = []

        viewModel?.resetGame()
        
        XCTAssertEqual(mockGameLogicCtrl.duration, 300)
        XCTAssertEqual(mockGameLogicCtrl.guessedWords.count, 0)
        XCTAssertEqual(mockGameLogicCtrl.remainingWords.count, 2)
        XCTAssertFalse(mockGameLogicCtrl.timer.isValid)
    }
}

