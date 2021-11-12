//
//  ScoreEditTableDataSource.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
 Represents the data soruce for a score edit table
 */
class ScoreEditTableDataSource: NSObject, UITableViewDataSource {
    /**
     The team score data soruce
     */
    public var scoreData: TeamScore
    
    /**
     The titles of the sections in the table
     */
    public let sectionTitles: [String] = [
        "Autonomous", "Driver-Controlled Period", "End Game"
    ]
    
    /**
     Definitions for the scores in the autonomous category
     */
    public let autonomousScores: [ScoreEdit] = [
        ScoreEditToggle(scoreLabel: "Delivered Duck via Carousel", scoreValue: 10),
        ScoreEditToggle(scoreLabel: "Parked In Alliance Storage Unit", scoreValue: 3),
        ScoreEditToggle(scoreLabel: "Parked Completely In Alliance Storage Unit", scoreValue: 6),
        ScoreEditToggle(scoreLabel: "Parked In Warehouse", scoreValue: 5),
        ScoreEditToggle(scoreLabel: "Parked Completely In Warehouse", scoreValue: 10),
        ScoreEditNumeric(scoreLabel: "Freight Completely In Alliance Storage Unit", scoreValue: 2),
        ScoreEditNumeric(scoreLabel: "Freight Completely On Alliance Shipping Hub", scoreValue: 6),
        ScoreEditToggle(scoreLabel: "Duck used to detect Shipping Hub Level", scoreValue: 10),
        ScoreEditToggle(scoreLabel: "Team Scoring Element detected Shipping Hub Level", scoreValue: 20),
    ]
    
    /**
     Definitions for the scores in the driver controlled category
     */
    public let driverControlledScores: [ScoreEdit] = [
        ScoreEditNumeric(scoreLabel: "Freight Completely In Storage Unit", scoreValue: 1),
        ScoreEditNumeric(scoreLabel: "Freight in Alliance Shipping Hub (L1)", scoreValue: 2),
        ScoreEditNumeric(scoreLabel: "Freight in Alliance Shipping Hub (L2)", scoreValue: 4),
        ScoreEditNumeric(scoreLabel: "Freight in Alliance Shipping Hub (L3)", scoreValue: 6),
        ScoreEditNumeric(scoreLabel: "Freight Completely On Shared Shipping Hub", scoreValue: 4),
    ]
    
    /**
     Definitions for the scores in the end game category
     */
    public let endGameScores: [ScoreEdit] = [
        ScoreEditNumeric(scoreLabel: "Delivered Duck or Team Shipping Element via Carousel", scoreValue: 6),
        ScoreEditToggle(scoreLabel: "Alliance Shipping Hub Balanced", scoreValue: 10),
        ScoreEditToggle(scoreLabel: "Shared Shipping Hub tipped toward Alliance", scoreValue: 20),
        ScoreEditToggle(scoreLabel: "Parked partially in a Warehouse", scoreValue: 3),
        ScoreEditToggle(scoreLabel: "Parked Completely in a Warehouse", scoreValue: 6),
        ScoreEditToggle(scoreLabel: "Alliance Shipping Hub Capped", scoreValue: 15),
    ]
    
    /**
     Define how many sections are within the table
    - Parameter in: Table view
    - Returns: The number of sections
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    /**
     Define the titles of the sections within the table view
     - Parameter tableView: Table view
     - Parameter titleForHeaderInSection: Section to get the title of
     - Returns: The section title
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    /**
     Define how many rows are in a specified section
     - Parameter tableView: Table view
     - Parameter numberOfRowsInSection: Section to get the rows of
     - Returns: The number of rows in a section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // autonomous score section
            return autonomousScores.count
        case 1: // driver controlled section
            return driverControlledScores.count
        case 2: // end game section
            return endGameScores.count
        default: // invalid
            return 0
        }
    }
    
    /**
     Update the table view with the cells needed for setting the score
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        var scoreEdit: ScoreEdit? = nil
        
        switch indexPath.section {
        case 0: // autonomous score section
            scoreEdit = autonomousScores[indexPath.row]
        case 1: // driver controlled section
            scoreEdit = driverControlledScores[indexPath.row]
        case 2: // end game section
            scoreEdit = endGameScores[indexPath.row]
        default: // invalid
            break
        }
        
        if let scoreEdit = scoreEdit {
            if scoreEdit is ScoreEditToggle {
                let editCell: ScoreEditTableCell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreEditTableCell
                
                editCell.scoreDataSource = self
                editCell.scoreEdit = scoreEdit as? ScoreEditToggle
                editCell.setLabels()
                
                cell = editCell
            } else {
                let editCell: ScoreEditTableNumericCell = tableView.dequeueReusableCell(withIdentifier: "scoreCellNumeric") as! ScoreEditTableNumericCell
                
                editCell.scoreDataSource = self
                editCell.scoreEdit = scoreEdit as? ScoreEditNumeric
                editCell.setLabels()
                
                cell = editCell
            }
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }

    override init() {
        scoreData = TeamScore(context: DataUtils.getManagedObject())
    }
}
