//
//  TextFieldNumericTextFieldDelegate.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 9/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Text field delegate for general use
 */
class TextFieldNumericTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /**
     Max length allowed for the text field
     */
    private var maxValue: Int
    
    /**
     Create a new text field delegate
     - Parameter maxLength: Max length of the string
     */
    public init(maxValue: Int) {
        self.maxValue = maxValue
    }
    
    /**
     Perform validation on the text field to ensure that the max length is ensured
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Create regex object to determine if only contains numbers
        let range = NSRange(location: 0, length: string.count)
        let regex = try! NSRegularExpression(pattern: "^[0-9]*$")
        
        // check if matches above regex
        if regex.firstMatch(in: string, options: [], range: range) != nil {
            // check if, when adding new string, the length is still within range
            if textField.text!.count + string.count <= maxValue {
                return true
            }
        }
        
        return false
    }
}
