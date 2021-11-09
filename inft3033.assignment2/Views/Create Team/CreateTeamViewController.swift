//
//  CreateTeamViewController.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit
import CoreData


class CreateTeamViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var teamImage: UIImageView!
    @IBOutlet var teamIdField: UITextField!
    @IBOutlet var teamNameField: UITextField!
    @IBOutlet var teamLocationField: UITextField!
    @IBOutlet var formView: UIView!
    @IBOutlet var progress: UIProgressView!
    
    var teamIdDelegate: TeamIdTextFieldDelegate
    var teamNameDelegate: TextFieldDelegate
    var teamLocationDelegate: TextFieldDelegate
    var imagePicker = UIImagePickerController()
    var imageData: Data?
    
    /**
     Value currently in the team ID field
     */
    var formTeamId: Int32? { get { Int32(self.teamIdField.text!) } }
    
    /**
     Value currently in the team name field
     */
    var formTeamName: String { get { self.teamNameField.text! } }
    
    /**
     Value currently in the team location field
     */
    var formTeamLocation: String { get { self.teamLocationField.text! } }
    
    /**
     Value currently in the team image field
     */
    var formTeamImage: Data? { get { self.imageData } }
    
    
    required init?(coder: NSCoder) {
        // Create delegates for use in the fields
        self.teamIdDelegate = TeamIdTextFieldDelegate()
        
        // Arbitary max length to prevent too much input
        self.teamNameDelegate = TextFieldDelegate(maxLength: 64)
        self.teamLocationDelegate = TextFieldDelegate(maxLength: 64)
        
        super.init(coder: coder)
        
        // Setup the image picker
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    /**
     Perform actions for when the view loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign delegates to their respective fields
        teamIdField.delegate = teamIdDelegate
        teamNameField.delegate = teamNameDelegate
        teamLocationField.delegate = teamLocationDelegate
        
        // Add tap gesure regocnizer for the image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        teamImage.addGestureRecognizer(tapGesture)
    }
    
    /**
     Stub for handling memory warnings
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     On submit event that should fire when the submit button is clicked
     */
    @IBAction func onSubmit() {
        let (isValid, reason) = validateInputs()
        
        if isValid {
            progress.isHidden = false
            progress.progress = 0
            progress.setProgress(0.6, animated: true)
            self.formView.isUserInteractionEnabled = false;
            
            // Check if teamId can be converted into int
            if let teamId = self.formTeamId {
                // Check if the team already exists on the server
                ApiTeamRequest.teamExists(withId: teamId, callback: { result in
                    DispatchQueue.main.async {
                        self.progress.setProgress(0.8, animated: true)
                        
                        switch result {
                        case .success(let exists):
                            // If team exists, show error to user
                            if exists {
                                self.showDialog(withTitle: "Error Saving Team", andMessage: "A team with the ID \(self.teamIdField.text!) already exists on the leaderboards")
                            } else {
                                self.progress.setProgress(0.9, animated: true)
                                
                                // Now check if the team already exists in coredata
                                if LocalTeam.teamExists(withId: teamId) {
                                    self.showDialog(withTitle: "Error Saving Team", andMessage: "You have already created a team with ID \(self.teamIdField.text!)")
                                } else {
                                    // Checks complete, now store the team data
                                    self.storeTeamData()
                                    self.closeView()
                                }
                            }
                            
                            self.progress.progress = 0
                            self.progress.isHidden = true
                            self.formView.isUserInteractionEnabled = true;
                        case .failure(let error):
                            self.showDialog(withTitle: "Error Saving Team", andMessage: "Your team could not be saved. Please try again later\n\(error)")
                            
                            self.progress.progress = 0
                            self.progress.isHidden = true
                            self.formView.isUserInteractionEnabled = true;
                        }
                    }
                })
            } else {
                self.showDialog(withTitle: "Invalid Input", andMessage: "The Team ID entered is invalid")
                
                self.progress.progress = 0
                self.progress.isHidden = true
                self.formView.isUserInteractionEnabled = true;
            }
        } else {
            showInvalidInputAlert(text: reason)
        }
    }
    
    /**
     On cancel event that should fire when the cancel button is clicked
     */
    @IBAction func onCancel() {
        self.closeView()
    }
    
    /**
     Method called when the image has been tapped
     - Parameter gesture: Gesure recogniser for the tap
     */
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // Check if available and check if the source is available
        if gesture.view as? UIImageView != nil {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {                
                // Present the image picker
                present(imagePicker, animated: true)
            }
        }
    }
    
    /**
     Method that is fired when the user selects an image within the image picker
     - Parameter picker: UI image picker controller
     - Parameter didFinishPickingMediaWithInfo: Info that was retrieved from picking the image
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // Get the image data and set as the team image
        let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        teamImage.image = image
        
        // Set the image data as PNG rep for use in CoreData
        imageData = image!.pngData()
        
        // Dismiss
        self.closeView()
    }
    
    /**
     Method that is fired when the user cancels the image picker
     - Parameter picker: UI Image picker controller
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Simply dismiss the image picker
        self.closeView()
    }
    
    /**
     Validate the user inputs
     - Returns: True if the inputs are valid, False if they are not and a reason.
     */
    private func validateInputs() -> (Bool, String) {
        
        // Check to see if formTeamId is nil
        if let formTeamId = formTeamId {
            // check if team ID is valid length
            if formTeamId > TeamIdTextFieldDelegate.MaxValue || formTeamId < TeamIdTextFieldDelegate.MinValue {
                return (false, "The Team ID needs to be 5 numbers in length")
            }
        } else {
            return (false, "The Team ID entered is invalid")
        }
        
        // check if team name entered
        if formTeamName.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Team name required")
        }
        
        // check if team location entered
        if formTeamLocation.trimmingCharacters(in: .whitespaces).isEmpty {
            return (false, "Team location required")
        }
        
        return (true, "")
    }
    
    /**
     Store the team data within CoreData
     */
    private func storeTeamData() {
        let entity = Team(context: DataUtils.getManagedObject())
        
        entity.teamId = formTeamId!
        entity.name = formTeamName
        entity.location = formTeamLocation
        entity.image = formTeamImage
        
        do {
            try DataUtils.getManagedObject().save()
        } catch let error as NSError {
            showDialog(withTitle: "Error Saving Team", andMessage: "Your team could not be saved. Please try again.\n\(error)")
        }
    }
    
    /**
     Method called during a segue prepare stage
     */
    func closeView() {
        self.dismiss(animated: true)
        TeamsViewController.Instance?.reload()
    }
    
    /**
     Shows an invalid input alert to the user
     - Parameter message: Message to show the user
     */
    private func showInvalidInputAlert(text message: String) {
        showDialog(withTitle: "Invalid Input", andMessage: message)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
