//
//  LoginViewController.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/10/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()


        let textFields = [usernameTextField, pwTextField]
        for textField in textFields{
            textField?.delegate = self
        }

        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.yellow.cgColor as CGColor
        let color2 = UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.4)
        let color3 = UIColor.clear.cgColor as CGColor
        //let color4 = UIColor.white.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.3).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.1, 0.4, 0.7, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1, y: -1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.view.layer.addSublayer(gradientLayer)
        self.view.backgroundColor = UIColor(red: 0.7882, green: 0.9904, blue: 0.6078, alpha: 1.0)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* UITextFieldDelegate methods */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear textField placeholder
        textField.text = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Put back placeholders if nothing was typed
        if(textField.text == "")
        {
            if(textField == usernameTextField)
            {
                textField.text = "Username"
            }
            else{
                textField.text = "Password"
            }
            textField.textColor = UIColor.black
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: pwTextField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("User logged in")

                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
