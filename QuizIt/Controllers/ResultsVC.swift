//
//  ResultViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-23.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class ResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var playerResultsTableView: UITableView!
    
    var quiz : Quiz?
    let db = Firestore.firestore()
    
    var playerNames = [String]()
    var playerScores = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerResultsTableView.delegate = self
        playerResultsTableView.dataSource = self
        //Getting all the necessary data from FireStore
        db.collection("Quiz").document(quiz!.quizPin).collection("Players").order(by: "score", descending: true).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else {
                print("Document data was empty.")
                return
            }
            self.playerNames = [String]()
            self.playerScores = [String]()
            
            for i in 0 ..< documents.count {
                let playerName = documents[i].documentID
                self.playerNames.append(playerName)
                
                let data = documents[i].data()
                let score = data["score"] as! Int
                
                self.playerScores.append(String(score))
            }
            self.playerResultsTableView.reloadData()
        }
    }
    
    @IBAction func quitButtonPressed(_ sender: UIButton) {
        //Quiting everything and goes back to startVC
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerResultsTableView.dequeueReusableCell(withIdentifier: "PlayerScoreCell", for: indexPath) as! PlayerScoreCell
        
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.playerNameLabel.text = playerNames[indexPath.row]
        cell.playerScoreLabel.text = playerScores[indexPath.row]
        
        return cell
    }
    
}
