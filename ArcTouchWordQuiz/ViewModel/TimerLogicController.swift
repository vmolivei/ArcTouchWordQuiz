//
//  TimerLogicController.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import Foundation

protocol TimerDelegate: class {
    func updateTimeLbl(with value: String)
    func timesUp()
}

class TimerLogicController {
    weak var delegate: TimerDelegate?
    var duration = 300
    var timer = Timer()
    
    func startTimer() {
        timer.invalidate()
        duration = 30
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatedTimer), userInfo: nil, repeats: true)
    }
    
    func getTimer() -> String {
        let min = (duration / 60) % 60
        let sec = duration % 60
        return String(format: "%02i:%02i", min, sec)
    }
    
    func timesUp() {
        timer.invalidate()
        delegate?.timesUp()
    }
    
    @objc func updatedTimer() {
        duration  = duration - 1
        delegate?.updateTimeLbl(with: getTimer())
        if duration == 0 {
            timesUp()
        }
    }
}
