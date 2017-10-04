//
//  RegisterSecurityQuestionsViewController.swift
//  Tsir
//
//  Created by Trevor Bullock on 9/20/17.
//  Copyright © 2017 TSIR Inc. All rights reserved.
//

import UIKit

class RegisterSecurityQuestionsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var securityQuestion1: UITextField!
    @IBOutlet weak var securityAnswer1: UITextField!
    @IBOutlet weak var securityQuestion2: UITextField!
    @IBOutlet weak var securityAnswer2: UITextField!
    @IBOutlet weak var securityQuestion3: UITextField!
    @IBOutlet weak var securityAnswer3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func back(_ sender: UIButton) {
        if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The Register Security Questions View Controller is not within a Naviagtion Controller.")
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
        return true;
    }
    
    //MARK: Private Methods
    
    private func getScreenSize() -> (height: CGFloat, width: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return (screenHeight, screenWidth)
    }

}
