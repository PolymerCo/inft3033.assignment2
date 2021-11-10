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
        ScoreEdit(scoreLabel: "Delivered Duck via Carousel", scoreValue: 10),
        ScoreEdit(scoreLabel: "Parked In Alliance Storage Unit", scoreValue: 3),
        ScoreEdit(scoreLabel: "Parked Completely In Alliance Storage Unit", scoreValue: 6),
        ScoreEdit(scoreLabel: "Parked In Warehouse", scoreValue: 5),
        ScoreEdit(scoreLabel: "Parked Completely In Warehouse", scoreValue: 10),
        ScoreEdit(scoreLabel: "Freight Completely In Alliance Storage Unit", scoreValue: 2),
        ScoreEdit(scoreLabel: "Freight Completely On Alliance Shipping Hub", scoreValue: 6),
        ScoreEdit(scoreLabel: "Duck used to detect Shipping Hub Level", scoreValue: 10),
        ScoreEdit(scoreLabel: "Team Scoring Element used to detect Shipping Hub Level", scoreValue: 20),
    ]
    
    /**
     Definitions for the scores in the driver controlled category
     */
    public let driverControlledScores: [ScoreEdit] = [
        ScoreEdit(scoreLabel: "Freight Completely In Alliance Storage Unit", scoreValue: 1),
        ScoreEdit(scoreLabel: "Freight in Alliance Shipping Hub (Level 1)", scoreValue: 2),
        ScoreEdit(scoreLabel: "Freight in Alliance Shipping Hub (Level 2)", scoreValue: 4),
        ScoreEdit(scoreLabel: "Freight in Alliance Shipping Hub (Level 3)", scoreValue: 6),
        ScoreEdit(scoreLabel: "Freight Completely On Shared Shipping Hub", scoreValue: 4),
    ]
    
    /**
     Definitions for the scores in the end game category
     */
    public let endGameScores: [ScoreEdit] = [
        ScoreEdit(scoreLabel: "Delivered Duck or Team Shipping Element via Carousel", scoreValue: 6),
        ScoreEdit(scoreLabel: "Alliance Shipping Hub Balanced", scoreValue: 10),
        ScoreEdit(scoreLabel: "Shared Shipping Hub tipped toward Alliance", scoreValue: 20),
        ScoreEdit(scoreLabel: "Parked partially in a Warehouse", scoreValue: 3),
        ScoreEdit(scoreLabel: "Parked Completely in a Warehouse", scoreValue: 6),
        ScoreEdit(scoreLabel: "Alliance Shipping Hub Capped", scoreValue: 15),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell") as! ScoreEditTableCell
        
        switch indexPath.section {
        case 0: // autonomous score section
            cell.scoreEdit = autonomousScores[indexPath.row]
        case 1: // driver controlled section
            cell.scoreEdit = driverControlledScores[indexPath.row]
        case 2: // end game section
            cell.scoreEdit = endGameScores[indexPath.row]
        default: // invalid
            break
        }
        
        cell.scoreDataSource = self
        cell.setLabels()
        
        return cell
    }

    override init() {
        scoreData = TeamScore(context: DataUtils.getManagedObject())
    }
}
