//
//  PlayerNameViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-24.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class JoinQuizVC: UIViewController, UITextFieldDelegate, ScannerDelegate {

    @IBOutlet weak var quizPinTextField: UITextField!
    @IBOutlet weak var playerNameTextField: UITextField!
    
    let db = Firestore.firestore()
    var quizPinGlobal = ""
    var playerNameGlobal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameTextField.delegate = self
        ProgressHUD.statusColor(#colorLiteral(red: 0.4156862745, green: 0.1725490196, blue: 0.4392156863, alpha: 1))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        playerNameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func scanQRPressed(_ sender: UIButton) {
        
    }
    //Joining quiz
    @IBAction func joinQuizPressed(_ sender: UIButton) {
        ProgressHUD.show("Joining quiz")
        guard let quizPin = quizPinTextField.text, !quizPin.isEmpty else {
            ProgressHUD.showError("You must enter a code")
            return
        }
        guard let playerName = playerNameTextField.text, !playerName.isEmpty else {
            ProgressHUD.showError("You must enter a name")
            return
        }
        quizPinGlobal = quizPin
        playerNameGlobal = playerName
        //Getting necessary data from FireStore
        db.collection("Quiz").document(quizPin).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                //Checking if game is joinable
                let gameIsJoinable = data["currentQuestion"] as! Int
                if gameIsJoinable == 0 {
                        //Joining game by setting setting player data
                    self.db.collection("Quiz").document(quizPin).collection("Players").document(playerName).setData([
                        "score": 0
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                self.performSegue(withIdentifier: "goToLobby", sender: nil)
                            }
                    }
                }else {
                    ProgressHUD.showError("Quiz already started")
                }
            } else {
                ProgressHUD.showError("Wrong code")
            }
        }
    }
    func didScanCode(code: String) {
        quizPinTextField.text = code
    }
    //Sending data to next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanSegue" {
            if let scanner = segue.destination as? ScannerViewController {
                scanner.scannerDelegate = self
            }
        }else {
            let destVC = segue.destination as! LobbyVC
            destVC.quizPin = quizPinGlobal
            destVC.playerName = playerNameGlobal
            ProgressHUD.dismiss()
            }
    }
}
