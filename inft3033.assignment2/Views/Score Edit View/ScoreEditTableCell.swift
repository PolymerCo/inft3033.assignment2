//
//  ScoreEditCell.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Represents a table cell within the score edit table
 */
class ScoreEditTableCell: UITableViewCell {
    // Label for the score edit cell
    @IBOutlet var label: UILabel!

    // Toggle input for the edit cell
    @IBOutlet var toggle: UISegmentedControl!
    
    /**
    The data source to use for this object
     */
    public var scoreDataSource: ScoreEditTableDataSource!
    
    /**
     The score edit parameters for this cell
     */
    public var scoreEdit: ScoreEditToggle!
    
    /**
     Method called when this cell changes
     */
    @IBAction func didChange() {
        scoreEdit.isToggled = toggle.selectedSegmentIndex == 1
    }

    /**
     Sets the labels on the cell using the current state of this object
     */
    public func setLabels() {
        label.text = "\(scoreEdit.scoreLabel) (+\(scoreEdit.scoreValue))"
        toggle.selectedSegmentIndex = scoreEdit.isToggled ? 1 : 0
    }
}
