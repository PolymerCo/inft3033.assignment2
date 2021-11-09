//
//  LocalTeamViewController.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//


import UIKit

class LeaderboardTeamViewController: UIViewController {
    @IBOutlet var teamNameLabel: UILabel!
    @IBOutlet var teamLocationLabel: UILabel!
    @IBOutlet var teamIdLabel: UILabel!
    @IBOutlet var teamAutonomousPointsLabel: UILabel!
    @IBOutlet var teamDriverControlPointsLabel: UILabel!
    @IBOutlet var teamEndGamePointsLabel: UILabel!
    @IBOutlet var teamTotalLabel: UILabel!
    @IBOutlet var teamPositionLabel: UILabel!
    @IBOutlet var teamPositionTotalLabel: UILabel!
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
        activity.startAnimating()
        
        // Check if required data is available and correct
        if TeamsViewController.SelectedTeam != nil && TeamsViewController.SelectedTeamType != nil && TeamsViewController.SelectedTeamType == "teamCellLeaderboard" {
            DispatchQueue.main.async {
                // get info from API object
                ApiTeamRequest.getTeam(withId: TeamsViewController.SelectedTeam!, callback: { (result) -> Void in
                    switch result {
                    case .success(let team):
                        self.apiTeam = team
                        
                        if let apiTeam = self.apiTeam {
                            ApiScoreRequest.getScore(forTeamId: Int32(apiTeam.id!) ?? 0, callback: { (result) -> Void in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let score):
                                        self.apiScore = score
                                        
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
                
                self.updateLabels()
                self.activity.stopAnimating()
            }
        })
    }
}
