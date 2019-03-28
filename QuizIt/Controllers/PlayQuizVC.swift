//
//  PlayerQuizViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-24.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class PlayQuizVC: UIViewController {

    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var alternative1: UIButton!
    @IBOutlet weak var alternative2: UIButton!
    @IBOutlet weak var alternative3: UIButton!
    @IBOutlet weak var alternative4: UIButton!
    
    var quizPin = ""
    let db = Firestore.firestore()
    var questionsArray = [Dictionary<String, Any>]()
    var correctAnswer = ""
    var playerName = ""
    var playerScore = 0
    var answers = 0
    var currentQuestion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting a listner to the quiz
        db.collection("Quiz").document(quizPin)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                self.answers = data["answers"] as! Int
                self.questionsArray = data["questions"] as! [Dictionary<String, Any>]
                
                // Changes the question if there is a new one
                if self.currentQuestion != data["currentQuestion"] as! Int {
                    self.currentQuestion = data["currentQuestion"] as! Int

                    self.defaultSettings()
                    
                    for question in self.questionsArray {
                        //Setting the right question to the views
                        if question["questionNumber"] as! Int == self.currentQuestion {
                            
                            self.currentQuestionLabel.text = "Question \(self.currentQuestion)"
                            self.currentQuestionLabel.sizeToFit()
                            
                            self.questionLabel.text = question["question"] as? String
                            self.questionLabel.sizeToFit()
                            
                            var answersArray = [String]()
                            for int in 1...4 {
                                answersArray.append(question["answerAlt\(int)"] as! String)
                            }
                            answersArray.shuffle()
                            
                            self.alternative1.setTitle(answersArray[0], for: .normal)
                            self.alternative2.setTitle(answersArray[1], for: .normal)
                            self.alternative3.setTitle(answersArray[2], for: .normal)
                            self.alternative4.setTitle(answersArray[3], for: .normal)
                            
                            self.correctAnswer = question["answerAlt1"] as! String
                        
                        }
                    }
                }
                //Checking if quiz is done
                if self.currentQuestion > self.questionsArray.count {
                    self.performSegue(withIdentifier: "goToResults", sender: nil)
                }
        }
    }
    //Setting alternative buttons to defualt settings
    func defaultSettings(){
        alternative1.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.5411764706, blue: 0.3647058824, alpha: 1)
        alternative2.backgroundColor = #colorLiteral(red: 0.4156862745, green: 0.1725490196, blue: 0.4392156863, alpha: 1)
        alternative3.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.231372549, blue: 0.368627451, alpha: 1)
        alternative4.backgroundColor = UIColor.purple
        
        alternative1.isEnabled = true
        alternative2.isEnabled = true
        alternative3.isEnabled = true
        alternative4.isEnabled = true
        
        alternative1.layer.borderWidth = 0
        alternative2.layer.borderWidth = 0
        self.alternative3.layer.borderWidth = 0
        self.alternative4.layer.borderWidth = 0
    }

    @IBAction func alternativePressed(_ sender: UIButton) {
        sender.layer.borderWidth = 4
        sender.layer.borderColor = #colorLiteral(red: 0.9764705882, green: 0.9294117647, blue: 0.4117647059, alpha: 1)
        
        alternative1.isEnabled = false
        alternative2.isEnabled = false
        alternative3.isEnabled = false
        alternative4.isEnabled = false
        //Updating how many has answered in FireStore
        db.collection("Quiz").document(quizPin).updateData([
            "answers": answers + 1,
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
        }
        //Checking if you answered right and sets the score
        if sender.titleLabel?.text == correctAnswer {
            playerScore += 1
            db.collection("Quiz").document(quizPin).collection("Players").document(playerName).updateData([
                "score": playerScore
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    //Sending data to the next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ResultsVC
        let quiz = Quiz()
        quiz.quizPin = quizPin
        destVC.quiz = quiz
    }
}
