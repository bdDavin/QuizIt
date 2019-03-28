//
//  PlayerJoinViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-24.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class LobbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var playerNamesTableView: UITableView!
    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    
    var quizPin = ""
    let db = Firestore.firestore()
    var playerNames = [String]()
    var playerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerNamesTableView.delegate = self
        playerNamesTableView.dataSource = self
        //Adding a listener to a quiz and getting necessary player data
        db.collection("Quiz").document(quizPin).collection("Players")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                self.playerNames = [String]()
                
                for i in 0 ..< documents.count {
                    let playerName = documents[i].documentID
                    self.playerNames.insert(playerName, at: 0)
                }
                self.playerNamesTableView.reloadData()
                
        }
        //Adding a listener to a quiz and getting necessary quiz data
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
                
                let questions = data["questions"] as! [Dictionary<String, Any>]
                let numberOfQuestions = questions.count
                self.numberOfQuestionsLabel.text = String(numberOfQuestions)
                
                //Checking if quiz started and goes to game
                let quizStarted = data["currentQuestion"] as! Int
                if quizStarted > 0 {
                    self.performSegue(withIdentifier: "goToGame", sender: nil)
                }
                
        }
    }
    //Sending data to next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! PlayQuizVC
        destVC.quizPin = quizPin
        destVC.playerName = playerName
    }
    
    //MARK: - TableView stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerNamesTableView.dequeueReusableCell(withIdentifier: "PlayerNameCell", for: indexPath) as! PlayerNameCell
        
        cell.playerNameLabel.text = playerNames[indexPath.row]
        return cell
    }
}
