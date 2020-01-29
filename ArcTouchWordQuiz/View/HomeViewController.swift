//
//  HomeViewController.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var infoViewBottomContraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WordQuizCommunicator.shared.fetchWordQuiz { (wordQuiz, error) in
            DispatchQueue.main.async {
                self.titleLbl.text = wordQuiz?.question
                self.startButton.setTitle("Start", for: .normal)
            }
        }
        
        inputField.delegate = self
        answerTableView.delegate = self
        answerTableView.dataSource = self

        layoutViews()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func layoutViews() {
        /// Fonts
        titleLbl.font = UIFont.boldSystemFont(ofSize: 34.0)
        scoreLbl.font = UIFont.boldSystemFont(ofSize: 34.0)
        timeLbl.font = UIFont.boldSystemFont(ofSize: 34.0)
        inputField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        
        /// Colors
        inputField.backgroundColor = UIColor(red: 0.960, green: 0.960, blue: 0.960, alpha: 1.0)
        infoView.backgroundColor = UIColor(red: 0.960, green: 0.960, blue: 0.960, alpha: 1.0)
        startButton.backgroundColor = UIColor(red: 1.0, green: 0.513, blue: 0.0, alpha: 1.0)
        startButton.tintColor = .white
        
        /// Shape
        startButton.clipsToBounds = true
        startButton.layer.cornerRadius = 8.0
    }
    
    func animateInfoViewPosition(with value: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.infoViewBottomContraint.constant = value
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            animateInfoViewPosition(with: keyboardSize.height * -1)
        }
    }
    
    func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Test"
        
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        animateInfoViewPosition(with: 0.0)
        
        return false
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        print(sender.text)
    }
}
