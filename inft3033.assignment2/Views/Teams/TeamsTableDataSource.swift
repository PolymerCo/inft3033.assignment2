//
//  TeamsTableDataSource.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Data source to provide data to the team view
 */
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
        // If first section, i.e local teams section
        if section == 0 {
            return LocalTeam.getTeams()?.count ?? 0
        }
        
        // Other section is the remote team leaderboards
        return min(TeamsViewController.Instance?.PreloadedSortedApiScores?.count ?? 0, 100)
    }
    
    /**
     Define the cells within the table
     - Parameter tableView: Table view
     - Parameter cellForRowAt: Cell to get the cell view of
     - Returns: The cell view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If first section, i.e local teams section
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell") as! TeamsTableCell
            
            // Get team at index indexPath
            let teams = LocalTeam.getTeams()
            
            if let teams = teams {
                let team = teams[indexPath.row]
                
                // Set the cell parameters
                cell.setTeamName(to: team.name!)
                cell.teamId = team.teamId
                
                // try and get scores for the team
                let score = LocalTeamScores.getScore(forTeamId: team.teamId)
                
                // If score is not set, set default to 0
                if let score = score {
                    cell.setTeamScore(to: score.score)
                } else {
                    cell.setTeamScore(to: 0)
                }
            }
            
            return cell
        }
        
        // Other section is the remote team leaderboards
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCellLeaderboard") as! TeamsTableCellLeaderboard
        
        // get scores first to ensure that teams without scores are not loaded
        if let preloadedScores = TeamsViewController.Instance?.PreloadedSortedApiScores {
            let score = preloadedScores[indexPath.row]
            
            // get team linked with score
            if let preloadedTeams = TeamsViewController.Instance?.PreloadedApiTeams {
                for team in preloadedTeams {
                    if team.id == score.teamid {
                        cell.setTeamName(to: team.name!)
                        cell.setTeamScore(to: Int(score.score!)!)
                        cell.teamId = Int32(team.id!)!
                        cell.setTeamPlace(to: indexPath.row + 1)
                        
                        break
                    }
                }
            }
        }
        
        return cell
    }
}
