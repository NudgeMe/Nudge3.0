//
//  MyCalendarViewController.swift
//  Nudge
//
//  Created by Lin Zhou on 5/21/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.


import UIKit
import EventKit

/** code reference: https://www.ioscreator.com/tutorials/add-event-calendar-tutorial-ios8-swift */
class MyCalendarViewController: UIViewController {
    
    //var tasks: Task[]

    override func viewDidLoad() {
        super.viewDidLoad()

        let group = NudgeHelper.getCurrentUserGroup()
        let currentUserTasks = group?.tasks
        
        
        
        //An EKEventStore object is created. This represents the Calendar's database
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event) { (granted,error) in
            
            if (granted) &&  (error == nil) {
                
                print("permission is granted")
                
                var currentUserActiveTasks = currentUserTasks
                //Check if tasks exist in the taskGroup, else return an empty cell
                if(currentUserTasks != nil)
                {
                    //Filters through the task array on those that are active
                    currentUserActiveTasks = currentUserTasks?.filter {
                        task in (task.isActive)
                    }
                    currentUserActiveTasks?.forEach({ (task) in
                        self.insertEvent(store: eventStore, task: task)
                    })
                    
                }
                
            }
            //TODO delete deleted event
            
            UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
        }
        /*
        //The authorizationStatusForEntityType method returns the authorisation status
        switch EKEventStore.authorizationStatus(for: EKEntityType.event){
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("calendar access denied")
        case .notDetermined:
            //If the status is not yet determined the user is prompted to deny or grant access using the requestAccessToEntityType(entityType:completion) method.
            eventStore.requestAccess(to: EKEntityType.event, completion:
                {[weak self] (granted: Bool, error: NSError?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            } as! EKEventStoreRequestAccessCompletionHandler)
        default:
            print("Case Default")
        }*/
    }
    
    func insertEvent(store: EKEventStore, task: Task) {
        // The calendarsForEntityType returns all calendars that supports events
        let calendars = store.calendars(for: EKEntityType.event)
        
        //check if NudgeCalendar is created
        var exists = false
        
        for calendar in calendars {
            if calendar.title == "Nudge Calendar" {
                exists = true
            }
        }
        //TOFIX
        if exists==false {
           let newCalendar = EKCalendar.init(for: EKEntityType.reminder, eventStore: store)
            //let newCalendar = EKCalendar(forEntityType: EKEntityType.reminder, eventStore: eventStore)
            newCalendar.title="Nudge Calendar"
            newCalendar.source = store.defaultCalendarForNewEvents.source
            do {try store.saveCalendar(newCalendar, commit: true)
            print("created new calendar")
        } catch {
            // Do error stuff here
            print("failed to create a new calendar")
        }
        }
        
        for calendar in calendars {
            // We check if the previously crested calendar "Nudge Calendar" exists
            if calendar.title == "Nudge Calendar" {
                // The event has a start date of the current time and an end date of 2 hours from the current time. (2 hours x 60 minutes x 60 seconds)
                let startDate = Date()
                // 2 hours
               // let endDate = startDate.addingTimeInterval(2 * 60 * 60)
                
                // Create Event
                var event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = task.title!
                event.startDate = startDate as Date
                event.endDate = task.dueDate
                   // endDate as Date
                
                // Save Event in Calendar
                do {
                    try store.save(event, span: .thisEvent)
                    print("saved event to calendar")
                } catch {
                    // Do error stuff here
                }
            }
        }
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
