//
//  CreateTaskViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 4/17/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class CreateTaskViewController: UIViewController {
    
    var newTask: Task?

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCreate(_ sender: Any) {
        let currentTaskGroup = NudgeHelper.getCurrentUserGroup()
        
        //If the taskGroup exists, then add task to taskGroup
        if(currentTaskGroup != nil)
        {
            //Create task
            let newTask = Task()
            
            newTask.title = titleTextField.text
            newTask.detail = descriptionTextField.text
            newTask.isActive = true
            newTask.dueDate = datePicker.date
            print(datePicker.date)
            print(newTask.dueDate)
            
            //Save task into Parse and add to taskGroup
            NudgeHelper.trySaveTask(task: newTask)
            NudgeHelper.addTaskToCurrentUserGroup(task: newTask)
        }
        
        self.performSegue(withIdentifier: "toMain", sender: nil)
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
