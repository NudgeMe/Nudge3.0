//
//  ProfileViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 4/15/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var realName: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    var image = UIImage()
    var users = [PFObject]()
    var groupID = [String]()
    var groupMember = [PFObject]()
    var groupMembers = [PFUser]()
    var hasRequestedForPFUser = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let user = NudgeHelper.getCurrentUser() {
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
                //print("in a group")
                //print("HELLO \(NudgeHelper.getCurrentUserGroup()!.name)" )
                groupLabel.text = NudgeHelper.getCurrentUserGroup()!.name

            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if NudgeHelper.getCurrentUserGroup() == nil{
            groupLabel.text = "No Group"
        }
        else{
            //print("in a group")
            //print("HELLO \(NudgeHelper.getCurrentUserGroup()!.name)" )
            groupLabel.text = NudgeHelper.getCurrentUserGroup()!.name
            
        }
    }
    
    func fetchUserInfo(){
        let query = PFQuery(className: "Image")
        query.whereKey("username", equalTo:"user")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            PFUser.logOutInBackground { (error: Error?) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogOut"), object: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
            return
        }))

        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Function to add a photo to profile picture
    @IBAction func onProfilePicture(_ sender: UIButton) {
        //print("Clicked button")
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
        Image.postUSerImage(image: image)
        self.pictureImageView.image = self.image
    }
    
    func fetchPic(){
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: PFUser.current()?.username!)
        
        query.findObjectsInBackground (block: { (users: [PFObject]?, error: Error?) in
            if let users = users{
                self.users = users
                
                let user = self.users[0]
                if let name = user["username"] as? String{
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
    
    //Segue to create group view
    @IBAction func onCreateGroup(_ sender: Any) {
        let user = PFUser.current()!
        let isInGroup = user["isInGroup"] as! Bool?
        if isInGroup == true {
            let alert = UIAlertController(title: "Oops", message: "Already in a group", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
           
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "newGroupSegue", sender: nil)
        }
    }
    
    //TableView for group members
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!hasRequestedForPFUser && NudgeHelper.getCurrentUser()?["groupId"] as? String != "")
        {
            getPFUsersByGroupId()
        }
        return groupID.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // cell selected code here
        //TODO: Show member's profile?
        groupMember = NudgeHelper.getPFObjectById(id: groupID[indexPath.row])!
        print("member nil? \(groupMember[0]["fullname"])")
        performSegue(withIdentifier: "toMemberProfile", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        if(!self.groupID.isEmpty)
        {
            groupMember = NudgeHelper.getPFObjectById(id: groupID[indexPath.row])!
            let memberName = NudgeHelper.getUsernameById(user: groupMember[0])
            cell.memberLabel.text = memberName
            
            if let profileImage = groupMember[0]["image"] as? PFFile{
                profileImage.getDataInBackground({ (imageData:Data?, error:Error?) in
                    if let imageData = imageData{
                        cell.profileImageView.image = UIImage(data: imageData)
                    }
                }   )
            }
        }
        return cell
    }
    
    /* Get group members */
    func getPFUsersByGroupId()
    {
        hasRequestedForPFUser = true
        let query = PFQuery(className: "_User")
        query.whereKey("groupId", equalTo: NudgeHelper.getCurrentUser()?["groupId"])
        
        query.findObjectsInBackground (block: { (users: [PFObject]?, error: Error?) in
            if let users = users{
                
                for user in users{
                    let name = user.object(forKey: "fullname") as! String
                    if(!self.groupID.contains(name) && user.objectId != NudgeHelper.getCurrentUser()?.objectId)
                    {
                        self.groupID.append(user.objectId!)
                    }
                }
                self.tableView.reloadData()
            }
            else{
                print(error?.localizedDescription)
            }
        })
    }
    
    /* Quit current group */
    @IBAction func onQuitGroup(_ sender: Any) {
        NudgeHelper.removeCurrentUserGroup(taskGroup: NudgeHelper.getCurrentUserGroup()!)
        groupLabel.text = "No Group"
        self.groupID.removeAll()
        self.tableView.reloadData()
    
    }
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     func prepare(for segue: UIStoryboardSegue, sender: UITableViewCell?) {
        if segue.identifier == "toMemberProfile"{
            let memberProfileVC = segue.destination as! MemberProfileViewController
            memberProfileVC.user = groupMember[0]
            
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    }
    
    
}
