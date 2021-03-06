//
//  ViewController.swift
//  PKSecurePinExample
//
//  Created by Praveen on 07/09/18.
//  Copyright © 2018 Praveen. All rights reserved.
//

import UIKit

public struct PKSecurePinError {
    var errorString:String
    var errorCode:Int
    var errorIsHidden:Bool
}

protocol PKSecureTextFieldDelegate {
    func secureTextFieldDidSelectDeleteButton(_ textField: UITextField) -> Void
    func secureTextFieldDidChange(_ textField: UITextField) -> Void
    func writeToTextFieldOnDidEndEditing(_ textField: UITextField, withDigit: Character) -> Void
    func updateError(_ error:PKSecurePinError)
}

class PKSecureTextField: UITextField {
    
    var deleteDelegate: PKSecureTextFieldDelegate?
    
    override func deleteBackward() {
        // Need to call this before super or the textfield edit may already be in place
        self.deleteDelegate?.secureTextFieldDidSelectDeleteButton(self)
        super.deleteBackward()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setTextButtomBorder()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configForTextField()
        self.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    func configForTextField() {
        
        self.isEnabled = false
        self.isSecureTextEntry = true
        self.textAlignment = .center
        self.keyboardType = .numberPad
        
        setTextButtomBorder()
    }
    
    func setTextButtomBorder() {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1.5)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(bottomBorder)
    }
}

extension PKSecureTextField: UITextFieldDelegate
{
    //MARK: UITextField delegate methods
    @objc func textFieldDidChange(textField: UITextField) {
        //block the execution or avoid executing the next use case if more than 1 digits entered
        if ((textField.text?.count)! > 1)
        {
            writeToTextField(textField, withDigit: (textField.text?.last)!)
            return
        }
        
        self.deleteDelegate?.secureTextFieldDidChange(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.deleteDelegate?.updateError(PKSecurePinError(errorString:"", errorCode: 103, errorIsHidden: true))
        return true
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print("UITextFieldDidEndEditingReason")
        
        //block the execution or avoid executing the next use case if more than 1 digits entered
        if ((textField.text?.count)! > 1) {
            writeToTextField(textField, withDigit: (textField.text?.last)!)
            return
        }
        self.deleteDelegate?.secureTextFieldDidChange(textField)
    }
    
    func writeToTextField(_ textField: UITextField, withDigit: Character) {
        textField.text = String(withDigit)
    }
}

