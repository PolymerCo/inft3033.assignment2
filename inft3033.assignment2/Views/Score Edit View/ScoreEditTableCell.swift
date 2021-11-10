//
//  ScoreEditCell.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit
import CoreData

/**
 Represents a table cell within the score edit table
 */
class ScoreEditTableCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var toggle: UISwitch!
    
    /**
    The data source to use for this object
     */
    public var scoreDataSource: ScoreEditTableDataSource!
    
    /**
     The score edit parameters for this cell
     */
    public var scoreEdit: ScoreEdit!
    
    /**
     Method called when this cell changes
     */
    @IBAction func didChange() {
        scoreEdit.scoreIsSet = toggle.isOn
    }

    /**
     Sets the labels on the cell using the current state of this object
     */
    public func setLabels() {
        label.text = "\(scoreEdit.scoreLabel) (+\(scoreEdit.scoreValue))"
        toggle.isOn = scoreEdit.scoreIsSet
    }
}
