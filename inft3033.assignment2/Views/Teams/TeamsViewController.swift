//
//  TeamsViewController.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Controller to manage the team view
 */
class TeamsViewController: UITableViewController {
    
    /**
     Current instance of the view controller
     */
    public static private(set) var Instance: TeamsViewController?
    
    /**
     Team that has been selected by clicking on it within the table view
     */
    public static private(set) var SelectedTeam: Int32?
    
    /**
     Type of the team that has been selected by clicking on it within the table view
     */
    public static private(set) var SelectedTeamType: String?
    
    /**
     Preloaded scores from the API server
     */
    public private(set) var PreloadedSortedApiScores: [ApiScoreModel]?
    
    /**
     Preloaded teams from the API server
     */
    public private(set) var PreloadedApiTeams: [ApiTeamModel]?
    
    /**
     Data source for the table
     */
    var dataSource: TeamsTableDataSource?
    
    
    /**
     Triggers a reload of the form
     */
    @IBAction public func reload() {
        self.refreshControl?.beginRefreshing()
        
        // Get scores from the server
        ApiScoreRequest.getScores(callback: { result -> Void in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.PreloadedSortedApiScores = result.sorted {
                        Int32($0.score!)! > Int32($1.score!)!
                    }
                    
                    // Now get the teams from the server
                    ApiTeamRequest.getTeams(callback: { result -> Void in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let result):
                                self.PreloadedApiTeams = result
                                
                                // remove unknown teams from resulting scores, have to do this as the getTeams record is not always accurate
                                // and can contain teams that have been deleted
                                self.PreloadedSortedApiScores = self.PreloadedSortedApiScores?.filter({ score -> Bool in
                                    return self.PreloadedApiTeams?.filter({ team -> Bool in
                                        return score.teamid == team.id
                                    }).count ?? 0 > 0
                                })
                            case .failure(_):
                                self.PreloadedApiTeams = nil
                                self.PreloadedSortedApiScores = nil
                            }
                            
                            // Reload table with results
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    })
                case .failure(_):
                    self.PreloadedSortedApiScores = nil
                }
            }
        })
    }
    
    /**
     Method run when the view loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TeamsViewController.Instance = self
        
        // Add refresh control for pull down to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        dataSource = TeamsTableDataSource()
        tableView.dataSource = dataSource
        
        // Reload view so the API results can be retrieved from the server
        self.reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = tableView.indexPathForSelectedRow
        if let selectedRow = selectedRow {
            let cell = tableView?.cellForRow(at: selectedRow)
           
            if let cell = cell {
                // If a local team cell, else is a leaderboard cell
                if cell.reuseIdentifier == "teamCell" {
                    TeamsViewController.SelectedTeam = (cell as! TeamsTableCell).teamId
                } else {
                    TeamsViewController.SelectedTeam = (cell as! TeamsTableCellLeaderboard).teamId
                }
                
                TeamsViewController.SelectedTeamType = cell.reuseIdentifier
                return
            }
        }
        
        // If nothing could be determined, set all to nil
        TeamsViewController.SelectedTeam = nil
        TeamsViewController.SelectedTeamType = nil
    }
    
    /**
     Method run when the table has requested a refresh
     */
    @objc func refresh(_ sender: AnyObject) {
        // Reload table view and end refreshing
        reload()
    }
}
