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
    
    @IBOutlet weak var infoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startButtonHeightConstraint: NSLayoutConstraint!
    
    let cellID = "WordsTableViewCell"
    var loadingIndicator = LoadingIndicator()
    var viewModel: HomeViewModelType = HomeViewModel()
    var gameStarted = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        inputField.delegate = self
        inputField.isUserInteractionEnabled = false

        setupTableView()
        layoutViews()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func loadData() {
        loadingIndicator.show(onView: self.view)
        
        viewModel.fetchData { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.loadingIndicator.hide(fromView: self.view)
                self.inputField.isHidden = false
                self.resetGameUI()
            }
        }
    }
    
    func setupTableView() {
        let nib = UINib(nibName: cellID, bundle: .main)
        answerTableView.register(nib, forCellReuseIdentifier: cellID)
        
        answerTableView.delegate = self
        answerTableView.dataSource = self
        answerTableView.separatorStyle = .none
    }

    func layoutViews() {
        /// Fonts
        titleLbl.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
        scoreLbl.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
        timeLbl.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
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
        
        /// Values
        titleLbl.text = nil
        scoreLbl.text = nil
        timeLbl.text = nil
        inputField.isHidden = true
        
    }
    
    func animateInfoViewPosition(with value: CGFloat) {
        UIView.animate(withDuration: 0.25) {
            self.infoViewBottomConstraint.constant = value
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        guard notification.name == UIResponder.keyboardWillShowNotification else {
            animateInfoViewPosition(with: 0)
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            animateInfoViewPosition(with: keyboardSize.height * -1)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func didTapStart(_ sender: Any) {
        guard gameStarted == false else {
            viewModel.resetGame()
            resetGameUI()
            return
        }
        
        gameStarted = true
        viewModel.startGame()
        startButton.setTitle("Reset", for: .normal)
        inputField.isUserInteractionEnabled = true
    }
    
    func resetGameUI() {
        gameStarted = false
        
        inputField.text = nil
        titleLbl.text = viewModel.getTitle()
        timeLbl.text = viewModel.getTimer()
        scoreLbl.text = viewModel.getScore()
        
        startButton.setTitle("Start", for: .normal)
        inputField.isUserInteractionEnabled = false
        answerTableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGuessedWords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? WordsTableViewCell
        cell?.titleLbl?.text = viewModel.guessedWord(for: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
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
        guard let word = sender.text else { return }
        if viewModel.checkWord(word) {
            DispatchQueue.main.async {
                self.inputField.text = nil
                self.scoreLbl.text = self.viewModel.getScore()
                self.answerTableView.reloadData()
            }
        }
    }
}

extension HomeViewController: GameDelegate {
    func gameCleared() {
        let msg = "Good Job! You found all the answers on time. Keep up with the great work."
        showEndGameAlert(for: "Congratulations", with: msg, actionTitle: "Play Again")
    }
    
    func updateTimeLbl(with value: String) {
        DispatchQueue.main.async {
            self.timeLbl.text = value
        }
    }
    
    func timesUp(with score: Int, of maxScore: Int) {
        let msg = "Sorry, time is up! You got \(score) out of \(maxScore) answers."
        showEndGameAlert(for: "Time finished", with: msg, actionTitle: "Try Again")
    }
    
    func showEndGameAlert(for title: String, with msg: String, actionTitle: String) {
        let alertCtrl = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            self.viewModel.resetGame()
            self.resetGameUI()
            alertCtrl.dismiss(animated: true, completion: nil)
        }
        
        alertCtrl.addAction(alertAction)

        present(alertCtrl, animated: true, completion: nil)
    }
    
}
