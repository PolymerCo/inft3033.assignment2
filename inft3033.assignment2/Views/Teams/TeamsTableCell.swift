//
//  TeamsTableCell.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

class TeamsTableCell: UITableViewCell {
    @IBOutlet var teamNameLabel: UILabel?
    @IBOutlet var teamScoreLabel: UILabel?
    
    /**
     Team ID of this cell
     */
    public var teamId: Int32?
    
    /**
     Sets the team name
     - Parameter to: New team name
     */
    public func setTeamName(to name: String) {
        teamNameLabel?.text = name
    }
    
    /**
     Sets the team score. Set to 0 for no score set
     - Parameter to: New score
     */
    public func setTeamScore(to score: Int32) {
        teamScoreLabel?.text = score == 0 ? StringUtils.NoPointsPlaceholder : "\(String(score)) \(StringUtils.PointsUnit)"
    }
}
