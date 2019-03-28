//
//  Question.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-18.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import Foundation

class Question {
    
    var questionNumber = 0
    var question = ""
    var answerAlt1 = ""
    var answerAlt2 = ""
    var answerAlt3 = ""
    var answerAlt4 = ""

    func objToData() -> [String:Any] {
        var data = [String:Any]()
        
        data["questionNumber"] = questionNumber
        data["question"] = question
        data["answerAlt1"] = answerAlt1
        data["answerAlt2"] = answerAlt2
        data["answerAlt3"] = answerAlt3
        data["answerAlt4"] = answerAlt4
        
        return data
    }
}
