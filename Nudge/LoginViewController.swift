//
//  LoginViewController.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/10/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLogin(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: pwTextField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("User logged in")

                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if PFUser.current() != nil {
//            self.performSegue(withIdentifier: "loginSegue", sender: nil)
//        }
//    }

    
    
}
