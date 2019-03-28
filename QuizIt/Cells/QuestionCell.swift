//
//  QuestionCell.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-19.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerAltTextField1: UITextField!
    @IBOutlet weak var answerAltTextField2: UITextField!
    @IBOutlet weak var answerAltTextField3: UITextField!
    @IBOutlet weak var answerAltTextField4: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
