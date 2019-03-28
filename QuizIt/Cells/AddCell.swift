//
//  AddCell.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-19.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

protocol AddCellDelegate {
    func addQuestionPressed()
}

class AddCell: UITableViewCell {
    var addCellDelegate: AddCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.addCellDelegate?.addQuestionPressed()
    }
}
