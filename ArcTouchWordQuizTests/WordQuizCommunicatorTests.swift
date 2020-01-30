//
//  WordQuizCommunicatorTests.swift
//  ArcTouchWordQuizTests
//
//  Created by Victor on 1/30/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import XCTest
@testable import ArcTouchWordQuiz

class WordQuizCommunicatorTests: XCTestCase {
    let url = URL(string: "https://codechallenge.arctouch.com/quiz/1")
    let sampleData = Data("Testing Data".utf8)
    
    var communicator: WordQuizCommunicator?
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)

        communicator = WordQuizCommunicator(urlSession: session)
    }

    override func tearDown() {
        communicator = nil
        URLProtocolMock.testURLs = [:]
    }
    
    func test_fetchWordQuiz_ValidData_NoError() {
        let expect = expectation(description: "Test valid data")
        let encode = JSONEncoder()
        let quiz = WordQuiz(question: "Test", answer: ["Test"])
        
        guard let data = try? encode.encode(quiz) else {
            XCTFail()
            return
        }
        
        URLProtocolMock.testURLs = [url: data]
        
        communicator?.fetchWordQuiz(completion: { (quiz, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(quiz)
            expect.fulfill()
        })
     
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fetchWordQuiz_InvalidData_Error() {
        let expect = expectation(description: "Test bad data")
        URLProtocolMock.testURLs = [url: sampleData]
        
        communicator?.fetchWordQuiz(completion: { (quiz, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(quiz)
            expect.fulfill()
        })
     
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fetchWordQuiz_ValidDataWithConnectionIssue_Error() {
        let expect = expectation(description: "Test connection error")
        let encode = JSONEncoder()
        let quiz = WordQuiz(question: "Test", answer: ["Test"])
        
        guard let data = try? encode.encode(quiz) else {
            XCTFail()
            return
        }
        
        URLProtocolMock.testURLs = [url: data]
        URLProtocolMock.hasError = true
        
        communicator?.fetchWordQuiz(completion: { (quiz, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(quiz)
            expect.fulfill()
        })
     
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockWordQuizCommunicator: WordQuizCommunicatorType {
    var quiz: WordQuizType?
    var error: WordQuizNetworkError?
    var urlSession: URLSession
    
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        self.urlSession = URLSession(configuration: config)
    }
    
    func fetchWordQuiz(completion: @escaping ((WordQuizType?, WordQuizNetworkError?) -> Void)) {
        completion(quiz, error)
    }
}

class URLProtocolMock: URLProtocol {
    // maps URLs to test data
    static var testURLs = [URL?: Data]()
    static var hasError = false

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if URLProtocolMock.hasError == false, let url = request.url, let data = URLProtocolMock.testURLs[url] {
            self.client?.urlProtocol(self, didLoad: data)
        } else {
            self.client?.urlProtocol(self, didFailWithError: NSError(domain: "Test", code: 500, userInfo: nil))
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}

