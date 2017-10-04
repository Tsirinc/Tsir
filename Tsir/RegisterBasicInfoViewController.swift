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
    //@IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var offsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Manage first name, last name, username, password and confirm password text fields through delegate callbacks
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Naviation Bar hiding
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIButton) {
        if let owningNavigationController = navigationController{
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //activeTextField = textField
        return true
    }
    
    //MARK: Private Methods
    
    private func updateSubmitButtonState() {
        
    }
    
    private func moveView(view: UIView, moveDistance: Int, up: Bool) {
        
    }
    
    @objc func keyboardFrameChangeNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let activeTextField = getActiveTextField()
            let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
            let animationCurveRawValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int) ?? Int(UIViewAnimationOptions.curveEaseInOut.rawValue)
            let animationCurve = UIViewAnimationOptions(rawValue: UInt(animationCurveRawValue))
            if let _ = endFrame, endFrame!.intersects(activeTextField!.frame) {
                self.offsetY = activeTextField!.frame.maxY - endFrame!.minY
                UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
                    self.view.frame.origin.y = self.view.frame.origin.y - self.offsetY
                }, completion: nil)
            }
            else if self.offsetY != 0 {
                    UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
                        self.view.frame.origin.y = self.view.frame.origin.y + self.offsetY
                        self.offsetY = 0
                    }, completion: nil)
            }
        }
    }
    
    /*@objc func keyboardWillChange(_ notification: NSNotification) {
        let activeTextField = getActiveTextField()
        //let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        //let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if activeTextField!.frame.intersects(targetFrame) {
            let offsetY = targetFrame.minY - activeTextField!.frame.maxY
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.view.frame.origin.y += offsetY
            },completion: {(true) in
                self.view.layoutIfNeeded()
            })
        }
        //let deltaY = targetFrame.origin.y - curFrame.origin.y
        

 }#*/
    
    private func getActiveTextField() -> UITextField! {
        let textFields = [firstNameTextField, lastNameTextField, usernameTextField, passwordTextField, confirmPasswordTextField]
        for textField in textFields {
            if textField!.isFirstResponder {
                print("\(textField!.description) is first responder.")
                return textField
            }
        }
        
        fatalError("No text field is currently the first responder.")
    }

}
