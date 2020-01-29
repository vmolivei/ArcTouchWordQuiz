//
//  HomeViewController.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        WordQuizCommunicator.shared.fetchWordQuiz { (wordQuiz, error) in
            DispatchQueue.main.async {
                self.lbl.text = wordQuiz?.question
            }
            print(wordQuiz?.question)
            print(error)
        }
        // Do any additional setup after loading the view.
    }

}
