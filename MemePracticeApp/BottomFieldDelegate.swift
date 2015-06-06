//
//  BottomFieldDelegate.swift
//  MemePracticeApp
//
//  Created by Rod Paras on 6/5/15.
//  Copyright (c) 2015 Rodacity. All rights reserved.
//

import Foundation

import UIKit

class BottomFieldDelegate : NSObject, UITextFieldDelegate {
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //Add replace string logic here if necessary
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {

          if textField.text == "-----------Bottom-----------" {
            textField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true;
    }
    
}