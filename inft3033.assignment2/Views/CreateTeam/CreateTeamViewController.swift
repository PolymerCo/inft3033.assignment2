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

    @IBOutlet var homeScreen: UIViewController!
    
    var teamIdDelegate: TeamIdTextFieldDelegate
    var teamNameDelegate: TextFieldDelegate
    var teamLocationDelegate: TextFieldDelegate
    
    var imagePicker = UIImagePickerController()
    
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
            self.dismiss(animated: true)
        }
        
        showInvalidInputAlert(text: reason)
    }
    
    /**
     On cancel event that should fire when the cancel button is clicked
     */
    @IBAction func onCancel() {
        dismiss(animated: true)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image data and set as the team image
        let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        teamImage.image = image
        
        // Dismiss
        dismiss(animated: true)
    }
    
    /**
     Method that is fired when the user cancels the image picker
     - Parameter picker: UI Image picker controller
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Simply dismiss the image picker
        dismiss(animated: true)
    }
    
    /**
     Validate the user inputs
     - Returns: True if the inputs are valid, False if they are not and a reason.
     */
    private func validateInputs() -> (Bool, String) {
        // check if team ID is valid length
        if teamIdField.text?.count != TeamIdTextFieldDelegate.MaxLength {
            return (false, "The Team ID needs to be 5 numbers in length")
        }
        
        // check if team name entered
        if teamNameField.text?.count == 0 {
            return (false, "Team name required")
        }
        
        // check if team location entered
        if teamLocationField.text?.count == 0 {
            return (false, "Team location required")
        }
        
        return (true, "")
    }
    
    private func storeTeamData() {
        
    }
    
    private func showInvalidInputAlert(text message: String) {
        let alertController = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}
