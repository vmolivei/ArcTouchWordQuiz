//
//  LoadingIndicator.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/29/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import UIKit

class LoadingIndicator: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadingWrapperView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("LoadingIndicator", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layoutView()
    }
    
    func layoutView() {
        contentView.backgroundColor = .none//UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        loadingWrapperView.layer.cornerRadius = 16.0
        loadingWrapperView.clipsToBounds = true
        
        activityIndicatorView.color = .white
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        
        titleLbl.tintColor = .white
        titleLbl.text = "Loading ..."
        
        overlayView.alpha = 0.5
        overlayView.backgroundColor = .black
    }
    
    func show(onView parent: UIView) {
        activityIndicatorView.startAnimating()
        
        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
        parent.layoutIfNeeded()
    }
    
    func hide(fromView parent: UIView) {
        activityIndicatorView.stopAnimating()
        
        parent.willRemoveSubview(self)
        self.removeFromSuperview()
        parent.layoutIfNeeded()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
