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
        
        datePicker.datePickerMode = .date
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Dismiss alert */
    func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreate(_ sender: Any) {
        let currentTaskGroup = NudgeHelper.getCurrentUserGroup()
        
        //If the taskGroup exists, then add task to taskGroup
        if(currentTaskGroup != nil)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"

            //Create task
            let newTask = Task()
            
            newTask.title = titleTextField.text
            newTask.detail = descriptionTextField.text
            newTask.dueDate = datePicker.date
            newTask.isActive = true
            
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())

            if(datePicker.date < yesterday!){
                //past dueDate
                newTask.pastDueDate = true
            }
            else{
                newTask.pastDueDate = false
            }
            
            //Save task into Parse and add to taskGroup
            NudgeHelper.trySaveTask(task: newTask)
            NudgeHelper.addTaskToCurrentUserGroup(task: newTask)
        }
        else{
            let alert = UIAlertController(title: "Please be in a group to make task", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            //dismiss alert
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
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
