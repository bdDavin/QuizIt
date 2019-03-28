//
//  Player.swift
//  QuizIt
//
//  Created by Ben Davin on 2019-03-18.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import Foundation

class Player {
    
    var name = ""
    var score = 0
    
    func objToData() -> [String:Any] {
        var data = [String:Any]()
        
        data["name"] = name
        data["score"] = score
        
        return data
    }
}
