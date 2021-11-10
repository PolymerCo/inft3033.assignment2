//
//  LocalTeamViewController.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//


import UIKit

class LocalTeamViewController: UIViewController, UIImagePickerControllerDelegate {
    public static var Instance: LocalTeamViewController?
    
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var formView: UIView!
    @IBOutlet var uploadButton: UIBarButtonItem!
    
    @IBOutlet var teamImage: UIImageView!
    @IBOutlet var teamNameLabel: UILabel!
    @IBOutlet var teamLocationLabel: UILabel!
    @IBOutlet var teamIdLabel: UILabel!
    @IBOutlet var teamAutonomousPointsLabel: UILabel!
    @IBOutlet var teamDriverControlPointsLabel: UILabel!
    @IBOutlet var teamEndGamePointsLabel: UILabel!
    @IBOutlet var teamTotalLabel: UILabel!
    @IBOutlet var teamPositionLabel: UILabel!
    @IBOutlet var teamPositionTotalLabel: UILabel!
    
    /**
     Local team loaded from the coredata store
     */
    private var localTeam: Team?
    
    /**
     Scores loaded from the coredata store
     */
    private var localTeamScore: TeamScore?
    
    /**
     On cancel event that should fire when the cancel button is clicked
     */
    @IBAction func onCancel() {
        // If data is invalid, dismiss view
        dismiss(animated: true)
    }
    
    /**
     Upload the team score to the server
     */
    @IBAction func uploadToServer() {
        // Set the states of the activity controls
        activity.isHidden = false
        formView.isUserInteractionEnabled = false
        uploadButton.isEnabled = false
        
        if let localTeam = localTeam {
            // Attempt to upload the team
            ApiTeamRequest.uploadTeam(withId: localTeam.teamId, withName: localTeam.name!, withLocation: localTeam.location!, callback: { (result) -> Void in
                DispatchQueue.main.async {
                    switch (result) {
                    case .success(_):
                        // If successful, check to see if the team has a score set
                        if let localTeamScore = self.localTeamScore {
                            // Attempt to upload the score
                            ApiScoreRequest.uploadScore(forId: localTeamScore.teamId, autonomous: localTeamScore.autonomous, drivercontrolled: localTeamScore.driverControlled, endgame: localTeamScore.endGame, location: localTeamScore.location!, callback: { (result) -> Void in
                                DispatchQueue.main.async {
                                    switch (result) {
                                    case .success(_):
                                        // Show dialog box if successful
                                        self.showDialog(withTitle: "Team Uploaded", andMessage: "Your team scores have been uploaded.")
                                    case .failure(_):
                                        self.showDialog(withTitle: "Failure Uploading", andMessage: "There was a failure uploading the team.\n\nPlease try again later.")
                                    }
                                    
                                    // Reset the states of the activity controls
                                    self.activity.isHidden = true
                                    self.formView.isUserInteractionEnabled = true
                                    self.uploadButton.isEnabled = true
                                }
                            })
                        }
                    case .failure(_):
                        self.showDialog(withTitle: "Failure Uploading", andMessage: "There was a failure uploading the team.\n\nPlease try again later.")
                        
                        self.activity.isHidden = true
                        self.formView.isUserInteractionEnabled = true
                        self.uploadButton.isEnabled = true
                    }
                }
            })
        }
    }
    
    override public func viewDidLoad() {
        // Set singleton instance and clear the labels
        LocalTeamViewController.Instance = self
        clearPositionLabel()
        
        activity.isHidden = true
        
        // Check if required data is available and correct
        if TeamsViewController.SelectedTeam != nil && TeamsViewController.SelectedTeamType != nil && TeamsViewController.SelectedTeamType == "teamCell" {
            // Get local team object
            localTeam = LocalTeam.getTeam(withId: TeamsViewController.SelectedTeam!)
            
            if let localTeam = localTeam {
                // Grab the scores for the team if available
                localTeamScore = LocalTeamScores.getScore(forTeamId: localTeam.teamId)
                
                // Update the labels
                updateLabels()
                return
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
        if let localTeam = localTeam {
            teamNameLabel.text = localTeam.name
            teamLocationLabel.text = localTeam.location
            teamIdLabel.text = "#\(localTeam.teamId)"
            
            if let img = localTeam.image {
                teamImage.image = UIImage(data: img)
            }
        }
        
        // Check if local team score is set, if not, set defaults
        if let localTeamScore = localTeamScore {
            teamTotalLabel.text = StringUtils.pointsString(of: Int(localTeamScore.score))
            teamAutonomousPointsLabel.text = StringUtils.pointsString(of: Int(localTeamScore.autonomous))
            teamDriverControlPointsLabel.text = StringUtils.pointsString(of: Int(localTeamScore.driverControlled))
            teamEndGamePointsLabel.text = StringUtils.pointsString(of: Int(localTeamScore.endGame))
        } else {
            teamTotalLabel.text = "N/A"
            teamAutonomousPointsLabel.text = "Not Recorded"
            teamDriverControlPointsLabel.text = "Not Recorded"
            teamEndGamePointsLabel.text = "Not Recorded"
        }
        
        setPositionLabel()
    }
    
    /**
     Clears the position labels to the default
     */
    private func clearPositionLabel() {
        self.teamPositionLabel.text = "-"
        self.teamPositionTotalLabel.text = "-"
    }
    
    /**
     Update the position label based  on the currently selected teams' points
     */
    private func setPositionLabel() {
        // Get API scores and get the count
        ApiScoreRequest.getScorePosition(usingScore: localTeamScore?.score ?? 0, callback: { (result) -> Void in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    // If team score is not set, use placeholder
                    if self.localTeamScore == nil {
                        self.teamPositionLabel.text = "N/A"
                    } else {
                        // Check to see if overflowed on the leaderboard, if so, set to the max value
                        if result.position > result.total {
                            self.teamPositionLabel.text = "\(result.total)"
                        } else {
                            self.teamPositionLabel.text = "\(result.position)"
                        }
                    }
                    
                    self.teamPositionTotalLabel.text = "/ \(result.total)"
                case .failure(_):
                    self.teamPositionLabel.text = "N/A"
                    self.teamPositionTotalLabel.text = "Error"
                }
            }
        })
    }
    
    /**
     Shows a dialog alert to the user
     - Parameter title: Title of the dialog
     - Parameter message: Message within the dialog
     */
    private func showDialog(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}
