//
//  MakerJoinViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-20.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase
import EFQRCode

class CreateLobbyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var quiz = Quiz()
    var playerNames : [String] = [String]()
    let db = Firestore.firestore()

    @IBOutlet weak var quizPinLabel: UILabel!
    @IBOutlet weak var qrCoddImage: UIImageView!
    @IBOutlet weak var playersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quizPinLabel.text = quiz.quizPin
        
        if let code = EFQRCode.generate(content: quiz.quizPin, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), foregroundColor: #colorLiteral(red: 0.9764705882, green: 0.9294117647, blue: 0.4117647059, alpha: 1)) {
            qrCoddImage.image = UIImage(cgImage: code)
        } else {
 
        }
        
        playersTableView.delegate = self
        playersTableView.dataSource = self
        
        //Setting a listener to a quiz and getting necessary player data
        db.collection("Quiz").document(quiz.quizPin).collection("Players")
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
                self.playersTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! HostVC
        destVC.quiz = quiz
        //updating currentQuestion in FireStore
        db.collection("Quiz").document(quiz.quizPin).updateData([
            "currentQuestion": 1,
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //MARK: - TableView stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playersTableView.dequeueReusableCell(withIdentifier: "PlayerNameCell", for: indexPath) as! PlayerNameCell
        
        cell.playerNameLabel.text = playerNames[indexPath.row]
        return cell
    }

}
