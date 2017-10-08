//
//  RegisterBasicInfoViewController.swift
//  Tsir
//
//  Created by Trevor Bullock on 9/18/17.
//  Copyright © 2017 TSIR Inc. All rights reserved.
//

import UIKit
import os.log

class RegisterBasicInfoViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var keyboardOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Manage first name, last name, username, password and confirm password text fields through delegate callbacks
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        //Add keyboard observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        updateNextButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unhide navigation bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //Remove keyboard observer
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("Register Basic Info View Controller is not within a Navigation Controller.")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateNextButtonState()
    }
    
    //MARK: Private Methods
    
    private func updateNextButtonState() {
            nextButton.isEnabled = textFieldsAreFilled() && isUniqueUsername() && areValidPasswordFields()
    }
    
    //Returns true if all text fields in this view controller have text inside them
    private func textFieldsAreFilled() -> Bool {
        return firstNameTextField.hasText && lastNameTextField.hasText && usernameTextField.hasText && passwordTextField.hasText && confirmPasswordTextField.hasText
    }
    
    private func isUniqueUsername() -> Bool {
        return true
    }
    
    private func areValidPasswordFields() -> Bool {
        return true
    }
    
    @objc func keyboardFrameChangeNotification(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let activeTextField = getActiveTextField()
        
        if(keyboardOffset == 0) {
            let textFieldFrame = activeTextField!.superview!.convert(activeTextField!.frame, to: self.view)
            if(targetFrame.minY < textFieldFrame.maxY) {
                keyboardOffset = textFieldFrame.maxY - targetFrame.minY
                UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIViewAnimationOptions(rawValue: curve), animations: {
                    self.view.frame.origin.y -= self.keyboardOffset
                }, completion: {(true) in
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.view.frame.origin.y += self.keyboardOffset
            }, completion: {(true) in
                self.view.layoutIfNeeded()
            })
            keyboardOffset = 0
        }
    }
    
    private func getActiveTextField() -> UITextField! {
        let textFields = [firstNameTextField, lastNameTextField, usernameTextField, passwordTextField, confirmPasswordTextField]
        for textField in textFields {
            if textField!.isFirstResponder {
                return textField!
            }
        }
        
        fatalError("No text field is currently the first responder.")
    }

}
