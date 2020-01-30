//
//  Constants.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

class Constants {
    static let wordQuizFetchPath = "https://codechallenge.arctouch.com/quiz/1"
}

enum WordQuizNetworkError {
    case badURL(_ error: Error)
    case badData(_ error: Error)
    case decodingError(_ error: Error)
}
