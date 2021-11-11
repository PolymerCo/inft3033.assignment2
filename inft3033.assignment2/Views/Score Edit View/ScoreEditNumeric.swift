//
//  ScoreEditNumeric.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 11/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//


class ScoreEditNumeric: ScoreEdit {
    
    var scoreLabel: String
    var scoreValue: Int
    
    /**
     Counter for adding the total score
     */
    var counter: Int = 0
    
    required init(scoreLabel: String, scoreValue: Int) {
        self.scoreLabel = scoreLabel
        self.scoreValue = scoreValue
    }
    
    func getCalculatedScore() -> Int {
        return self.counter * scoreValue
    }
}
