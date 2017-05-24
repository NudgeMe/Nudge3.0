//
//  MemberProfileViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 5/21/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class MemberProfileViewController: UIViewController {

    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var realnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var user: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //profilePicImageView.image = user["image"] as? UIImage
        realnameLabel.text = user["fullname"] as? String
        usernameLabel.text = user["username"] as? String
        groupNameLabel.text = NudgeHelper.getCurrentUserGroup()!.name
        bioLabel.text = user["bio"] as? String
        
        if let profileImage = user["image"] as? PFFile{
            profileImage.getDataInBackground({ (imageData:Data?, error:Error?) in
                if let imageData = imageData{
                    self.profilePicImageView.image = UIImage(data: imageData)
                }
            })
        }
        
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

}
