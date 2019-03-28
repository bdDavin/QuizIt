//
//  MakerQuestionsViewController.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-19.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class CreateQuestionsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddCellDelegate {
    
    var quiz = Quiz()
    var questions = [Question]()

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var questionsTable: UITableView!
    
    //FIXME: - Fixa så allt sparas i tableview och inte försvinner när cellen går utanför synfältet eller bygga upp controller på helt annant sätt
    override func viewDidLoad() {
        super.viewDidLoad()
    
        topLabel.text = quiz.name

        questionsTable.delegate = self
        questionsTable.dataSource = self
        
        let question = Question()
        question.questionNumber = 1
        questions.append(question)
    }
    
    //Creating new question and adds to table
    func addQuestionPressed() {
        
        let question = Question()
        question.questionNumber = questions.count + 1
        questions.append(question)
        
        questionsTable.reloadData()
    }
    
    func saveQuestionsData(){
        for index in 0..<questions.count {
            let indexPath = IndexPath(row: index,section: 0)
            
            let cell = questionsTable.cellForRow(at: indexPath) as! QuestionCell
            
            questions[index].question = cell.questionTextField.text!
            questions[index].answerAlt1 = cell.answerAltTextField1.text!
            questions[index].answerAlt2 = cell.answerAltTextField2.text!
            questions[index].answerAlt3 = cell.answerAltTextField3.text!
            questions[index].answerAlt4 = cell.answerAltTextField4.text!
            
            print(questions[index].question)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Saving all the questions and sending to next viewController
        saveQuestionsData()
        
        quiz.questions = questions

        let destVC = segue.destination as! CreateSettingsVC
        destVC.quiz = quiz

    }
    // MARK: - TableView Stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == questions.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
            
            cell.addCellDelegate = self
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! QuestionCell
            
            cell.questionNumberLabel.text = "Question \(questions[indexPath.row].questionNumber):"

            return cell
        }
    }
}
