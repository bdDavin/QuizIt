//
//  MakerSettingsViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-20.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class CreateSettingsVC: UIViewController {
    
    var quiz = Quiz()
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Creating a random number
        let number1 = Int.random(in: 0...9)
        let number2 = Int.random(in: 0...9)
        let number3 = Int.random(in: 0...9)
        let number4 = Int.random(in: 0...9)
        let pin = "\(number1)\(number2)\(number3)\(number4)"
        quiz.quizPin = pin
        print(quiz.quizPin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CreateLobbyVC
        destVC.quiz = quiz
        //Converting from Object to Dictionary
        var questionsData : [Dictionary<String, Any>] = [Dictionary<String, Any>]()
        for question in quiz.questions{
            questionsData.append(question.objToData())
        }
        //Setting up the data in the FireStore
        db.collection("Quiz").document(quiz.quizPin).setData([
            "name": quiz.name,
            "desc": quiz.description,
            "questions": questionsData,
            "currentQuestion": 0,
            "answers": 0
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
 
    }
}
