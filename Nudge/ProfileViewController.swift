//
//  ProfileViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 4/15/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = PFUser.current()?.username

        // Do any additional setup after loading the view.
        /*let currentUser = PFUser.current()
        print(currentUser?.objectId)
        
        //let currentUserGroupId = currentUser?["groupId"] as! String
        //print(currentUserGroupId)
        let userQuery = PFQuery(className: "TaskGroup")

        do {
            let groupObject = try userQuery.getObjectWithId(currentUserGroupId)
            let taskGroup = groupObject as! TaskGroup
            print("loaded current user group id: " + taskGroup.objectId!)
        }
        catch let error {
            print(error)
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        
        //TODO confirm b4 logout
        PFUser.logOutInBackground { (error: Error?) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogOut"), object: nil)
            
        }
    }

    //Function to add a photo to profile picture
    @IBAction func onProfilePicture(_ sender: UIButton) {
        print("Clicked button")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(vc, animated: true, completion: nil)
        sender.isHidden = true
    }
    //Set profile picture as the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Set image
        pictureImageView.image = originalImage
        
        //Dismiss imagePIckerController to go back to original view controller
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onProfileCreateGroup(_ sender: Any) {
        self.performSegue(withIdentifier: "newGroupSegue", sender: nil)

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
