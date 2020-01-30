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
    var viewModel = HomeViewModel()
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
        loadingIndicator.show(onView: self.view)
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        setupInfoView()
//    }
    
    func loadData() {
        viewModel.fetchData { (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.loadingIndicator.hide(fromView: self.view)
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
        inputField.becomeFirstResponder()
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
        
    }
    
    func updateTimeLbl(with value: String) {
        DispatchQueue.main.async {
            self.timeLbl.text = value
        }
    }
    
    func timesUp() {
    }
    
}
