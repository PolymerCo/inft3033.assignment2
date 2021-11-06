//
//  TeamsTableDataSource.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

class TeamsTableDataSource: NSObject, UITableViewDataSource {
    /**
     Titles to use in each of the sections
     */
    let sectionTitles = [
        "Your Teams",
        "Leaderboard"
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
        return 5
    }
    
    /**
     Define the cells within the table
     - Parameter tableView: Table view
     - Parameter cellForRowAt: Cell to get the cell view of
     - Returns: The cell view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! TeamsTableCell
            
            cell.setTeamName(to: "Team \(indexPath.row)")
            cell.setTeamScore(to: indexPath.row)
            cell.teamId = String(indexPath.row)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellLeaderboard") as! TeamsTableCellLeaderboard
        
        cell.setTeamPlace(to: indexPath.row + 1)
        cell.setTeamName(to: "Team \(indexPath.row)")
        cell.setTeamScore(to: indexPath.row)
        cell.teamId = String(indexPath.row)
        
        return cell
    }
}
