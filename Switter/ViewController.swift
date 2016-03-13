//
//  ViewController.swift
//  Switter
//
//  Created by Forrest Collins on 6/12/15.
//  Copyright (c) 2015 Forrest Collins. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {

    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var switterTableView: CustomTableView!
    
    var timelineData: NSMutableArray = NSMutableArray()
    
    //-----------------------------------------------
    // MARK: - Load Data
    //         loads all the tweets from the database
    //-----------------------------------------------
    func loadData()
    {
        // every time we load data, we want to get rid of everything that is already stored
        timelineData.removeAllObjects()
        
        let findTimelineData:PFQuery = PFQuery(className: "Tweets")
        
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects, error) in
            
            // if no error occurred we will iterate through the array of objects and add the new object
            if error == nil{
                for object in objects! {
                    let tweet:PFObject = object as! PFObject
                    self.timelineData.addObject(tweet)
                }
                
                let array:NSArray = self.timelineData.reverseObjectEnumerator().allObjects
                self.timelineData = NSMutableArray(array: array)
                
                self.switterTableView.reloadData()
            }
        }
    }

    //----------------------------------------------------------
    // MARK: - View Did Appear
    //         show an alert to sign in/sign up
    //         reload the tableview to display the tweet created
    //----------------------------------------------------------
    override func viewDidAppear(animated: Bool) {
        
        // first we will check if a user is already logged in
        // if there is no current user, we will give a user the opportunity
        // to sign up or log in.
        // we will create an alert controller for a user to sign into the app
        self.loadData()
        
        if PFUser.currentUser() == nil{
            let loginAlert:UIAlertController = UIAlertController(title: "Sign Up / Login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            // we use two textfields within our configuration handler
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            // we make the password field with secure text entry
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your password"
                textfield.secureTextEntry = true
            })
            
            // we create two actions, one for login and one for sign up
            // the textfields have to be in an array where you store the textfields in the loginAlert
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as AnyObject! as! NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as! UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as! UITextField
                
                // let the user login with username and password
                PFUser.logInWithUsernameInBackground(usernameTextfield.text!, password: passwordTextfield.text!){
                    (user, error) in
                    if user != nil{
                        // FUTURE change this to a UIAlert with an ok action
                        print("Login successful")
                    }else{
                        
                        let errorString = error!.localizedDescription
                        print(errorString)
                        
                        self.presentViewController(loginAlert, animated: true, completion: nil)
                    }
                }
            }))
            
            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as AnyObject! as! NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as! UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as! UITextField
                
                let sweeter:PFUser = PFUser()
                sweeter.username = usernameTextfield.text
                sweeter.password = passwordTextfield.text
                
                sweeter.signUpInBackgroundWithBlock{
                    (success, error) in
                    if error == nil{
                        print("Sign Up successful")
                    }else{
                        let errorString = error!.localizedDescription
                        print(errorString)
                        
                        self.presentViewController(loginAlert, animated: true, completion: nil)
                    }
                }
            }))
            
            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
    }

    //----------------------------------------------
    // MARK: - Table View Cell for Row at Index Path
    //----------------------------------------------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:SwitterTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SwitterTableViewCell
        
        // when you divide the indexPath.row by 2 you will have either 0 or 1
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clearColor()
        }
            
        else{
            // set cell opacity
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        // we need to get the right tweet to display in the right cell
        // this PFObject contains all of the data that we need
        // remember that we have to cast all these things! (ex. PFobject)
        let tweet: PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        //create a cool view transition
        // also add this to the findTweeter if statement
        cell.usernameLabel.alpha = 0
        cell.timestampLabel.alpha = 0
        cell.switterCellTextView.alpha = 0
        
        // add data to our view
        cell.switterCellTextView.text = tweet.objectForKey("content") as! String
        
        
        // **** CHANGE LABEL TO USERNAME ****
        // get the username, since there is only an object id stored in the user...
        // ...we need to run another query to get all the data we need.
        // we make this a PFUser.query because we are querying the users
        // the name of the tweeter goes in the equalTo and we want the object ID
        let findTweeter: PFQuery = PFUser.query()!
        findTweeter.whereKey("objectId", equalTo: tweet.objectForKey("personWhoSentTweet")!.objectId!!)
        findTweeter.findObjectsInBackgroundWithBlock{
            (objects, error) in
            if error == nil {
                // we should find just one user
                // we use an NSArray because we can get the last object (only object) method stored in an array
                let user:PFUser = (objects! as NSArray).lastObject as! PFUser
                // once we have found the user, we can change the label to the tweeter's username
                cell.usernameLabel.text = user.username
                
                
                UIView.animateWithDuration(1.0, animations: {
                    cell.usernameLabel.alpha = 1
                    cell.timestampLabel.alpha = 1
                    cell.switterCellTextView.alpha = 1
                })
            }
        }
        
        // **** CHANGE LABEL TO DATE ****
        let dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "dd HH:mm"
        cell.timestampLabel.text = dataFormatter.stringFromDate(tweet.createdAt!)

         return cell
    }
    
    //---------------------------------------------
    // MARK: - Table View Number of Rows in Section
    //---------------------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // returns number of elements stored in timeline data array
        return timelineData.count
    }
    
    //---------------------------------------
    // MARK: - Reload Button Tapped, loadData
    //---------------------------------------
    @IBAction func reloadButtonTapped(sender: AnyObject) {
        loadData()
    }
}

