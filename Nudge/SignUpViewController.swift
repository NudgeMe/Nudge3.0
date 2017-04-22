//
//  SignUpViewController.swift
//  Nudge
//
//  Created by Thuan Nguyen on 4/16/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse
class SignUpViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        
        //TODO test for errors
        
        newUser.username = userNameTextField.text
        newUser.password = passwordTextField.text
        newUser["isInGroup"] = false
        newUser["Phone"] = phoneTextField.text
        newUser["Address"] = addressTextField.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success {
                print("Created a user")
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error?.localizedDescription)
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
