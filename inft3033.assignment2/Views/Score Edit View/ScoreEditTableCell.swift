//
//  ScoreEditCell.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit
import CoreData

class ScoreEditTableCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var toggle: UISwitch!
    
    public var scoreDataSource: ScoreEditTableDataSource!
    public var scoreEdit: ScoreEdit!
    
    /**
     Method called when this cell changes
     */
    @IBAction func didChange() {
        scoreEdit.scoreIsSet = toggle.isOn
    }

    public func setLabels() {
        label.text = "\(scoreEdit.scoreLabel) (+\(scoreEdit.scoreValue))"
        toggle.isOn = scoreEdit.scoreIsSet
    }
}
