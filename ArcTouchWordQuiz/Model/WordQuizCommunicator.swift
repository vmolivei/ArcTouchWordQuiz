//
//  WordQuizCommunicator.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol  WordQuizCommunicatorType {
    func fetchWordQuiz(completion: @escaping ((WordQuizType?, WordQuizNetworkError?) -> Void))
    var urlSession: URLSession { get }
}

public class WordQuizCommunicator: WordQuizCommunicatorType {
    let urlSession: URLSession
    static var shared = WordQuizCommunicator()
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchWordQuiz(completion: @escaping ((WordQuizType?, WordQuizNetworkError?) -> Void)) {
    
        guard let url = URL(string: Constants.wordQuizFetchPath) else {
            completion(nil, .badURL(NSError()))
            return
        }
        
        urlSession.dataTask(with: url, completionHandler: {(data, res, err) in
            let decoder = JSONDecoder()
            
            guard let data = data else {
                completion(nil, .badData(err ?? NSError()))
                return
            }
            
            do {
                let decodedData = try decoder.decode(WordQuiz.self, from: data)
                completion(decodedData, nil)
            } catch{
                completion(nil, .decodingError(error))
            }
        }).resume()
    }
}
