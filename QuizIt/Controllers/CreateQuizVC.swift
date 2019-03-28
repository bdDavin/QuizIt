//
//  MakerNameViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-18.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class CreateQuizVC: UIViewController {
    
    let quiz = Quiz()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            ProgressHUD.showError("You must enter a quiz name")
            return
        }
        // Creating a Quiz and setting a name
        quiz.name = name
        
        let description = descriptionTextView.text!
        quiz.description = description
        
        performSegue(withIdentifier: "goToCreateQuestions", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Sending the quiz to the next ViewController
        let destVC = segue.destination as! CreateQuestionsVC
        destVC.quiz = quiz
    }
    
}
