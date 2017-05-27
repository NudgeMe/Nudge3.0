//
//  LauchViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 5/26/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit

class LauchViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //usleep(10000000); //wait for 10s
        
        //animation
        left()
        segue()
//        usleep(5000000);
//        left()
        
        
//        UIView.animate(withDuration: 0.5) {
//            self.iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(45 * Double.pi / 180))
//        }
//        //usleep(5000000);
//        UIView.animate(withDuration: 3.5) {
//            self.iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-45 * Double.pi / 180))
//        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func turnLeft(){
        UIView.animate(withDuration: 0.6, animations: {
                self.iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(65 * Double.pi / 180))
            
        }) { (Bool) in
            self.iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-65 * Double.pi / 180))
        }
        
        
    }
    
    func turnRight(){
        UIView.animate(withDuration: 0.3, animations: {
            self.iconImageView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi / 180))
            
        }) { (Bool) in
            usleep(2000000)
            self.segue()
        }
    }
    
    func segue(){
        self.performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    func left(){
        turnLeft()
        
//        UIView.animate(withDuration: 0.2, animations: {
//            self.iconImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//            
//        })
        usleep(1000000)
        //turnLeft()
        usleep(1000000)
        turnRight()
        usleep(1000000)
        segue()
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
