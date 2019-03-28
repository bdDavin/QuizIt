//
//  ViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-07.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
//Design classes
class MyBackround: UIView {
    override func didMoveToWindow() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = [#colorLiteral(red: 0.7215686275, green: 0.231372549, blue: 0.368627451, alpha: 1).cgColor, #colorLiteral(red: 0.4156862745, green: 0.1725490196, blue: 0.4392156863, alpha: 1).cgColor]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class MyButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 5
        
        self.layer.borderColor = #colorLiteral(red: 0.7215686275, green: 0.231372549, blue: 0.368627451, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.9764705882, green: 0.9294117647, blue: 0.4117647059, alpha: 1), for: .normal)
        self.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
}

class MyTextField: UITextField {
    override func didMoveToWindow() {
        self.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.5411764706, blue: 0.3647058824, alpha: 1).cgColor
        self.layer.borderWidth = 1.0
    }
    
}

class MyTableView: UITableView {
    override func didMoveToWindow() {
        self.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.5411764706, blue: 0.3647058824, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
    }
}


