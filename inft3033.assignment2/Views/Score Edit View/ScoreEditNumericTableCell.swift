//
//  ScoreEditNumericTableCell.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 11/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Represents a table cell within the score edit table
 */
class ScoreEditTableNumericCell: UITableViewCell {
    // Label to display on a numeric input cell
    @IBOutlet var label: UILabel!

    // Stepper that is used to incremenent/decrement the value
    @IBOutlet var stepper: UIStepper!

    // Label to display the current value of the stepper
    @IBOutlet var stepperLabel: UILabel!
    
    /**
    The data source to use for this object
     */
    public var scoreDataSource: ScoreEditTableDataSource!
    
    /**
     The score edit parameters for this cell
     */
    public var scoreEdit: ScoreEditNumeric!
    
    /**
     Method called when this cell changes
     */
    @IBAction func didChange() {
        let value: Int = Int(stepper.value)
        scoreEdit.counter = value
        
        if scoreEdit.counter > 0 {
            stepperLabel.textColor = UIColor.link
        } else {
            stepperLabel.textColor = UIColor.label
        }
        
        stepperLabel.text = "\(value)"
    }

    /**
     Sets the labels on the cell using the current state of this object
     */
    public func setLabels() {
        label.text = "\(scoreEdit.scoreLabel) (+\(scoreEdit.scoreValue))"
        stepper.value = Double(scoreEdit.counter)
        stepperLabel.text = "\(scoreEdit.counter)"
    }
}
