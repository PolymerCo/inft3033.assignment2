//
//  ScoreEditView.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ScoreEditViewController: UITableViewController, CLLocationManagerDelegate {
    
    /**
     Location manager
     */
    let locationManager = CLLocationManager()
    
    /**
     Location string that is dynamically updated until save
     */
    var locationString: String = ""
    
    /**
     Data source for the table
     */
    var dataSource: ScoreEditTableDataSource?
    
    @IBAction func save() {
        let scores = calculateTotalScores()
        let team = TeamsViewController.SelectedTeam
        
        // If score already exists, update this score
        if let existingScore = LocalTeamScores.getScore(forTeamId: team!) {
            existingScore.created = Date()
            existingScore.score = Int32(scores.total)
            existingScore.autonomous = Int32(scores.auto)
            existingScore.driverControlled = Int32(scores.driver)
            existingScore.endGame = Int32(scores.end)
            existingScore.location = locationString
        } else {
            let score = TeamScore(context: DataUtils.getManagedObject())
            
            score.teamId = team!
            score.created = Date()
            score.score = Int32(scores.total)
            score.autonomous = Int32(scores.auto)
            score.driverControlled = Int32(scores.driver)
            score.endGame = Int32(scores.end)
            score.location = locationString
        }
        
        do {
            try DataUtils.getManagedObject().save()
            LocalTeamViewController.Instance?.viewDidLoad()
            dismiss(animated: true)
        } catch { }
    }
    
    /**
     Calculates the final scores based on the entered data
     - Returns: Scores in the format (Total, Autonomous, Driver Controlled, End Game)
     */
    func calculateTotalScores() -> (total: Int, auto: Int, driver: Int, end: Int) {
        var total: Int = 0;
        var totalAuto: Int = 0;
        var totalDriver: Int = 0;
        var totalEnd: Int = 0;
        
        if let source = dataSource?.autonomousScores {
            for score in source {
                if score.scoreIsSet {
                    totalAuto += score.scoreValue
                }
            }
        }
        
        if let source = dataSource?.driverControlledScores {
            for score in source {
                if score.scoreIsSet {
                    totalDriver += score.scoreValue
                }
            }
        }
        
        if let source = dataSource?.endGameScores {
            for score in source {
                if score.scoreIsSet {
                    totalEnd += score.scoreValue
                }
            }
        }
        
        total = totalAuto + totalDriver + totalEnd
        return (total, totalAuto, totalDriver, totalEnd)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        dataSource = ScoreEditTableDataSource()
        tableView.dataSource = dataSource
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationString = "\(locValue.latitude)°N, \(locValue.longitude)°E"
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
