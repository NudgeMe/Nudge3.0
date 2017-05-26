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
    @IBOutlet weak var iconImageView: UIImageView!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        let textFields = [usernameTextField, pwTextField]
        for textField in textFields{
            textField?.delegate = self
        }
        
        
        //animation with icon 
        // code from https://stackoverflow.com/questions/3703922/how-do-you-create-a-wiggle-animation-similar-to-iphone-deletion-animation
        let originalCenter = iconImageView.center
        UIView.animate(withDuration: 20.0) {
            self.iconImageView.center = CGPoint(x: originalCenter.x-300, y:originalCenter.y)
        }
        
        //wiggle animation
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.04 , 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = 0.115
        transformAnim.repeatCount = Float.infinity
        iconImageView.layer.add(transformAnim, forKey: "tansform")
        
        createGradientLayer()
        /*
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.yellow.cgColor as CGColor
        let color2 = UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.4)
        let color3 = UIColor.clear.cgColor as CGColor
        //let color4 = UIColor.white.cgColor as CGColor
        let color4 = UIColor(white: 0.0, alpha: 0.3).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.2, 0.4, 0.7, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.view.layer.addSublayer(gradientLayer)*/
        
        self.view.backgroundColor = //UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            UIColor(red: 0.7882, green: 0.9904, blue: 0.6078, alpha: 1.0)
        createGradientLayer()

        // Do any additional setup after loading the view.
    }
    
    func createGradientLayer() {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.8),UIColor(red: 0.8882, green: 0.8004, blue: 0.3078, alpha: 1.0)]
        
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        
        
        /*gradientLayer.colors = [UIColor(red: 0.1765, green: 0.898, blue: 0.1, alpha: 1.0), UIColor(red: 0.9882, green: 0.9882, blue: 0.1, alpha: 1.0)]
        gradientLayer.colors = [UIColor(red: 0.6882, green: 0.9904, blue: 0.4078, alpha: 0.8),UIColor(red: 0.8882, green: 0.8004, blue: 0.3078, alpha: 1.0)]
                                //UIColor.yellow.cgColor]*/
        
        self.view.layer.addSublayer(gradientLayer)
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
