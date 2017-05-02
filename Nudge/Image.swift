//
//  Image.swift
//  Nudge
//
//  Created by Lin Zhou on 4/23/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class Image: PFObject{
    var image: UIImage?
    var realname: String?
    var username: String?
    
    class func postUSerImage(image: UIImage?) {
        
        //let user = PFObject(className: "User")
        
        let user = PFUser.current()!
        
        
        user["image"] = getPFFileFromImage(image: image)
        // user["username"] = PFUser.current()?.username as String!
        // user["realname"] = "REALNAME"
        user.saveInBackground()
        print("saved user")
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image{
            if let imageData = UIImagePNGRepresentation(image){
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}


