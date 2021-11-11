//
//  ScoreEdit.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

/**
 A class to represent the attributes of a score edit cell
 */
protocol ScoreEdit {
    
    /**
     Init class
     */
    init(scoreLabel: String, scoreValue: Int);
    
    /**
     Gets the score
     */
    func getCalculatedScore() -> Int;
    
    /**
     Score label for the display
     */
    var scoreLabel: String { get set }
    
    /**
     Value of the score
     */
    var scoreValue: Int { get set }
}
