//
//  WordQuiz.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol WordQuizType {
    var question: String {get set}
    var answer: [String] {get set}
}

class WordQuiz: WordQuizType, Codable {
    var question: String
    var answer: [String]
    
    init(question: String, answer: [String]) {
        self.question = question
        self.answer = answer
    }
}
