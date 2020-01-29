//
//  WordQuizCommunicator.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol  WordQuizCommunicatorType {
    func fetchWordQuiz(completion: @escaping ((WordQuizType?, Error?) -> Void))
}

public class WordQuizCommunicator: WordQuizCommunicatorType {
    static var shared = WordQuizCommunicator()
    
    func fetchWordQuiz(completion: @escaping ((WordQuizType?, Error?) -> Void)) {
    
        guard let url = URL(string: Constants.wordQuizFetchPath) else {
            completion(nil, NSError())
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, res, err) in
            let decoder = JSONDecoder()

            guard let data = data else {
                completion(nil, err ?? NSError())
                return
            }
            
            do {
                let decodedData = try decoder.decode(WordQuiz.self, from: data)
                completion(decodedData, nil)
            } catch{
                completion(nil, error)
            }
        }).resume()
        
    }
}
