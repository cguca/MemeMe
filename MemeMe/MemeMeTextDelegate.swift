//
//  MemeMeTextDelegate.swift
//  MemeMe
//
//  Created by Cary Guca on 2/18/21.
//

import Foundation
import UIKit

class MemeMeTextDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "BOTTOM" || textField.text! == "TOP" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! == "" {
            if textField.tag == 0 {
                textField.text = "TOP"
            } else {
                textField.text = "BOTTOM"
            }
        }
    }
}
