//
//  TeamsTableCellLeaderboard.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

class TeamsTableCellLeaderboard: UITableViewCell {
    @IBOutlet var teamPlaceLabel: UILabel?
    @IBOutlet var teamNameLabel: UILabel?
    @IBOutlet var teamScoreLabel: UILabel?
    
    /**
     Team ID of this cell
     */
    public var teamId: Int32?
    
    @IBAction func cellAction() {
        
    }
    
    /**
     Sets the team place
     - Parameter to: New team place
     */
    public func setTeamPlace(to place: Int) {
        teamPlaceLabel?.text = StringUtils.placeString(of: place)
    }
    
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
    public func setTeamScore(to score: Int) {
        teamScoreLabel?.text = score == 0 ? StringUtils.NoPointsPlaceholder : "\(String(score)) \(StringUtils.PointsUnit)"
    }
}
