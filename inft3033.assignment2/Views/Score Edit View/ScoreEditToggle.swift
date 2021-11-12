//
//  ScoreEditToggle.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 11/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

/**
 Manages a score edit for toggleable values
 */
class ScoreEditToggle: ScoreEdit {
    /**
     Label to display within the score field
     */
    var scoreLabel: String
    
    /**
     Value of the point
     */
    var scoreValue: Int
    
    /**
     If the toggle is currently on
     */
    var isToggled: Bool = false
    
    required init(scoreLabel: String, scoreValue: Int) {
        self.scoreLabel = scoreLabel
        self.scoreValue = scoreValue
    }
    
    func getCalculatedScore() -> Int {
        return isToggled ? self.scoreValue : 0
    }
}
