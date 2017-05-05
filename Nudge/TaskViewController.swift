//
//  TaskViewController.swift
//  Nudge
//
//  Created by Dephanie Ho on 4/10/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var taskCount = 0
    var currentUserGroup: TaskGroup? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        //Load tasks here
        let currentUserGroup = NudgeHelper.getCurrentUserGroup()
        
        //Check if user has a taskGroup
        if(currentUserGroup != nil)
        {
            self.currentUserGroup = currentUserGroup
            let currentUserTasks = currentUserGroup?.tasks
            
            //Check if tasks exist in the taskGroup, else return an empty cell
            if(currentUserTasks != nil)
            {
                //Filters through the task array on those that are active
                let currentUserActiveTasks = currentUserTasks?.filter {
                    task in task.isActive
                }
                return (currentUserActiveTasks?.count)!
            }
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(self.currentUserGroup != nil)
        {
            let currentUserTasks = currentUserGroup?.tasks
            
            //Check if tasks exist in the taskGroup, else return an empty cell
            if(currentUserTasks != nil)
            {
                //Filters through the task array on those that are active
                let currentUserActiveTasks = currentUserTasks?.filter {
                    task in task.isActive
                    //taskCount += 1
                }
                
                if((currentUserActiveTasks?.count)! > 0)
                {
                    //Active tasks exist, display them as onto the cells
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell", for: indexPath) as! TaskViewCell
                    let allTasks = currentUserActiveTasks?[indexPath.row]
                    cell.task = allTasks
                    return cell
                }
            }
        }
        return UITableViewCell()
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
