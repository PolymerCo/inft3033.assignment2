//
//  ScoreEdit.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

class ScoreEdit {
    
    /**
     Init class
     */
    init(scoreLabel: String, scoreValue: Int) {
        self.scoreLabel = scoreLabel
        self.scoreValue = scoreValue
    }
    
    /**
     Score label for the display
     */
    public var scoreLabel: String
    
    /**
     Numeric value for the score
     */
    public var scoreValue: Int
    
    /**
     If the score should be set when calculating
     */
    public var scoreIsSet: Bool = false
}
