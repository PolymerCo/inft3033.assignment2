//
//  DigitTextField.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Text field delegate specifically for the TeamID field
 */
class TeamIdTextFieldDelegate: NSObject, UITextFieldDelegate {
    /**
     Max possible length of the field
     */
    static var MaxLength = 5
    
    /**
     Perform validation on team ID to ensure that the following critera are true:
        1. The text does not contain anything except numerical characters
        2. The text does not exceed 5 characters in length
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create regex object to determine if only contains numbers
        let range = NSRange(location: 0, length: string.count)
        let regex = try! NSRegularExpression(pattern: "^[0-9]*$")
        
        // check if matches above regex
        if regex.firstMatch(in: string, options: [], range: range) != nil {
            // check if, when adding new string, the length is still within range
            if textField.text!.count + string.count <= TeamIdTextFieldDelegate.MaxLength {
                return true
            }
        }
        
        return false
    }
}
