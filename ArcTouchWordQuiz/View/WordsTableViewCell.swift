//
//  WordsTableViewCell.swift
//  ArcTouchWordQuiz
//
//  Created by Victor on 1/30/20.
//  Copyright © 2020 Victor. All rights reserved.
//

import UIKit

class WordsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorView.backgroundColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
