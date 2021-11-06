//
//  TextFieldDelegate.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

/**
 Text field delegate for general use
 */
class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /**
     Max length allowed for the text field
     */
    private var maxLength: Int
    
    /**
     Create a new text field delegate
     - Parameter maxLength: Max length of the string
     */
    public init(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    /**
     Perform validation on the text field to ensure that the max length is ensured
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text!.count + string.count <= maxLength
    }
}
