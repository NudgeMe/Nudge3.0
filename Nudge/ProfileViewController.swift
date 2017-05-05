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
    
    @IBOutlet weak var realName: UILabel!
    
    @IBOutlet weak var groupLabel: UILabel!
    
    var image = UIImage()
    var users = [PFObject]()
    //var users = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //usernameLabel.text = PFUser.current()?.username
        if let user = PFUser.current() {
            usernameLabel.text = user.username
            realName.text = user["fullname"] as? String
            fetchPic()
            
            var user2: PFUser!{
                didSet{
                    if let profileImage = user["image"] as? PFFile{
                        profileImage.getDataInBackground({ (imageData:Data?, error:Error?) in
                            if let imageData = imageData{
                                self.pictureImageView.image = UIImage(data: imageData)
                            }
                        }   )
                    }
                }
            }
            

            if NudgeHelper.getCurrentUserGroup() == nil{
                groupLabel.text = "No Group"
            }
            else{
                print("in a group")
                print("HELLO \(NudgeHelper.getCurrentUserGroup()!.name)" )
                groupLabel.text = NudgeHelper.getCurrentUserGroup()!.name

            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //TODO
    func fetchUserInfo(){
        let query = PFQuery(className: "Image")
        query.whereKey("username", equalTo:"user")
        
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
        
        //save image
        image = originalImage
        postImage()
        
        //Dismiss imagePIckerController to go back to original view controller
        dismiss(animated: true, completion: nil)
    }
    
    func postImage(){
        print("posting image")
        
        Image.postUSerImage(image: image)
        print("chosen image")
        self.pictureImageView.image = self.image
        //self.fetchPic()
    }
    
    func fetchPic(){
        print("fetching profile picture")
        let query = PFQuery(className: "_User")
        //pictureImageView.image = image
        query.whereKey("username", equalTo: PFUser.current()?.username!)
        
        query.findObjectsInBackground (block: { (users: [PFObject]?, error: Error?) in
            if let users = users{
                print("finding users")
                self.users = users
                
                let user = self.users[0]
                if let name = user["username"] as? String{
                    print("finding pics\(name)")
                }
                if let profileImage = user["image"] as? PFFile{
                    profileImage.getDataInBackground({ (imageData:Data?, error:Error?) in
                        if let imageData = imageData{
                            self.pictureImageView.image = UIImage(data: imageData)
                        }
                    })
                }
            }
            else{
                print ("ERROR \(error?.localizedDescription)")
            }
        })
    }
    
    
    @IBAction func onCreateGroup(_ sender: Any) {
        let user = PFUser.current()!
        let isInGroup = user["isInGroup"] as! Bool?
        if isInGroup == true {
            let alert = UIAlertController(title: "Oops", message: "Already in a group", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "newGroupSegue", sender: nil)
        }
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
