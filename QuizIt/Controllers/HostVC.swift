//
//  MakerHostViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-22.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class HostVC: UIViewController {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var playersAnsweredLabel: UILabel!
    
    var quiz : Quiz?
    let db = Firestore.firestore()
    var questionNumber = 1
    var questionsArray: [Dictionary<String, Any>] = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting listener to a quiz and getting necessery quiz data
        db.collection("Quiz").document(quiz!.quizPin)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                self.questionsArray = data["questions"] as! [Dictionary<String, Any>]
                for question in self.questionsArray {
                    if question["questionNumber"] as! Int == self.questionNumber {
                        self.questionLabel.text = question["question"] as? String
                        self.questionLabel.sizeToFit()
                        if self.questionNumber == self.questionsArray.count{
                            self.questionNumberLabel.text = "Last question"
                            self.buttonText.setTitle("Results", for: .normal)
                        }else{
                            self.questionNumberLabel.text = "Question \(self.questionNumber)"
                        }
                    }
                }
                //Getting necessary player data
                self.db.collection("Quiz").document(self.quiz!.quizPin).collection("Players")
                    .getDocuments{ querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        
                        self.playersAnsweredLabel.text = "\(data["answers"] as! Int)/\(documents.count)"
                        self.playersAnsweredLabel.sizeToFit()
                }
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        questionNumber += 1
        //Checking if there is questions left and goes to the next one or to results
        if questionNumber <= questionsArray.count {
            db.collection("Quiz").document(quiz!.quizPin).updateData([
                "currentQuestion": questionNumber,
                "answers": 0
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        
                    }
                }
        }else{
            db.collection("Quiz").document(quiz!.quizPin).updateData([
                "currentQuestion": questionNumber,
                "answers": 0
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.performSegue(withIdentifier: "showResults", sender: nil)
                }
            }
        }
    }
    //Sending data to the next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ResultsVC
        destVC.quiz = quiz
    }
    
}
