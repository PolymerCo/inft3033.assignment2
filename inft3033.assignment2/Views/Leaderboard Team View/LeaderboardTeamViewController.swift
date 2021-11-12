//
//  LocalTeamViewController.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//


import UIKit

/**
 View controller that manages the view for showing a leaderboard team
 */
class LeaderboardTeamViewController: UIViewController {
    // Team name label
    @IBOutlet var teamNameLabel: UILabel!

    // Team location label
    @IBOutlet var teamLocationLabel: UILabel!

    // Team ID label
    @IBOutlet var teamIdLabel: UILabel!

    // Label to display the total autonomous points
    @IBOutlet var teamAutonomousPointsLabel: UILabel!

    // Label to display the total driver control points
    @IBOutlet var teamDriverControlPointsLabel: UILabel!

    // Label to display the total end game points
    @IBOutlet var teamEndGamePointsLabel: UILabel!

    // Label to display the total points
    @IBOutlet var teamTotalLabel: UILabel!

    // Team position overall label
    @IBOutlet var teamPositionLabel: UILabel!

    // Team position total label
    @IBOutlet var teamPositionTotalLabel: UILabel!

    // Activity indicator
    @IBOutlet var activity: UIActivityIndicatorView!
    
    /**
     Local team loaded from the coredata store
     */
    private var apiTeam: ApiTeamModel?
    
    /**
     Scores loaded from the coredata store
     */
    private var apiScore: ApiScoreModel?
    
    /**
     On cancel event that should fire when the cancel button is clicked
     */
    @IBAction func onCancel() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        activity.isHidden = false
        
        // Check if required data is available and correct
        if TeamsViewController.SelectedTeam != nil && TeamsViewController.SelectedTeamType != nil && TeamsViewController.SelectedTeamType == "teamCellLeaderboard" {
            DispatchQueue.main.async {
                // get info from API object
                ApiTeamRequest.getTeam(withId: TeamsViewController.SelectedTeam!, callback: { (result) -> Void in
                    switch result {
                    case .success(let team):
                        self.apiTeam = team
                        
                        // if the API team object has been set
                        if let apiTeam = self.apiTeam {
                            // Send off another request to get details about the teams score
                            ApiScoreRequest.getScore(forTeamId: Int32(apiTeam.id!) ?? 0, callback: { (result) -> Void in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let score):
                                        // Set the score object based on the result
                                        self.apiScore = score
                                        
                                        // If there is an API score, set the labels
                                        if self.apiScore != nil {
                                            self.updateLabels()
                                        } else {
                                            // If data is invalid, dismiss view
                                            self.dismiss(animated: true)
                                        }
                                    case .failure(_):
                                        // If data is invalid, dismiss view
                                        self.dismiss(animated: true)
                                    }
                                }
                            })
                        } else {
                            // If data is invalid, dismiss view
                            self.dismiss(animated: true)
                        }
                    case .failure(_):
                        // If data is invalid, dismiss view
                        self.dismiss(animated: true)
                    }
                })
            }
        }
        
        // If data is invalid, dismiss view
        dismiss(animated: true)
    }
    
    /**
     Update the labels using the currently selected team
     */
    private func updateLabels() {
        // If local team is set
        if let apiTeam = apiTeam {
            teamNameLabel.text = apiTeam.name
            teamLocationLabel.text = apiTeam.location
            teamIdLabel.text = "#\(apiTeam.id!)"
        }
        
        // Check if local team score is set, if not, set defaults
        if let apiScore = apiScore {
            teamTotalLabel.text = StringUtils.pointsString(of: Int(apiScore.score!) ?? 0)
            teamAutonomousPointsLabel.text = StringUtils.pointsString(of: Int(apiScore.autonomous!) ?? 0)
            teamDriverControlPointsLabel.text = StringUtils.pointsString(of: Int(apiScore.drivercontrolled!) ?? 0)
            teamEndGamePointsLabel.text = StringUtils.pointsString(of: Int(apiScore.endgame!) ?? 0)
        } else {
            // Set default values if no score set
            teamTotalLabel.text = "N/A"
            teamAutonomousPointsLabel.text = "Not Recorded"
            teamDriverControlPointsLabel.text = "Not Recorded"
            teamEndGamePointsLabel.text = "Not Recorded"
        }
        
        setPositionLabel()
    }
    
    /**
     Update the position label based  on the currently selected teams' points
     */
    private func setPositionLabel() {
        
        // Get API scores and get the count
        ApiScoreRequest.getScorePosition(usingScore: Int32(apiScore?.score ?? "0") ?? 0, callback: { (result) -> Void in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    // If API score is not available set placeholder
                    if self.apiScore == nil {
                        self.teamPositionLabel.text = "N/A"
                    } else {
                        self.teamPositionLabel.text = "\(result.position)"
                    }
                    
                    self.teamPositionTotalLabel.text = "/ \(result.total)"
                case .failure(_):
                    self.teamPositionLabel.text = "N/A"
                    self.teamPositionTotalLabel.text = "Error"
                }
                
                // Update the labels
                self.updateLabels()
                self.activity.isHidden = true
            }
        })
    }
}
