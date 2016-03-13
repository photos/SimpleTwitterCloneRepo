//
//  ComposeViewController.swift
//  Switter
//
//  Created by Forrest Collins on 6/12/15.
//  Copyright (c) 2015 Forrest Collins. All rights reserved.
//
//        **** means important
//        ### means need to fix/work on
//

import UIKit
import Parse

class ComposeViewController: UIViewController, UITableViewDelegate, UITextViewDelegate{

    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var switterTextView: CustomTextView!
    
    //----------------------
    // MARK: - View Did Load
    //----------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blurry.jpg")!)
    
        self.automaticallyAdjustsScrollViewInsets = false
        
        switterTextView.delegate = self
        
        // bring up the keyboard for the textview
        switterTextView.becomeFirstResponder()
  
    }
    
    //----------------------
    // MARK: - Touches Began
    //         End editing
    //----------------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // when the user touches outside the keyboard, close it
        self.view.endEditing(true)
    }
    
    //---------------------------
    // MARK: - Done Button Tapped
    //         Send post
    //---------------------------
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        // send post
        // we will need to create a PFObject and a class called Tweets
        // we will have two columns: the content of the tweet and the person who sent the tweet
        // currentUser is the current user who logged into our app
        // saveInBackground saves the information to the Parse database
        let tweet: PFObject = PFObject(className: "Tweets")
        tweet["content"] = switterTextView.text
        tweet["personWhoSentTweet"] = PFUser.currentUser()
        tweet.saveInBackground()
        
        // go back to the userfeed timeline navigation controller
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //----------------------------------------------------
    // MARK: - Text View Should Change Text in Range
    //         we can restrict a number of characters that 
    //         are allowed and we can update our counter.
    //         emojis count as 2 characters.
    //----------------------------------------------------
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
            
            let newLength:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            let remainingChar:Int = 140 - (newLength)
            
            characterCountLabel.text = "\(remainingChar)"
            
            // make this 139 because it will go to -1 in the character count
            // it will allow more characters if there are less than 139 characters, else no
            // it is read "if length is greater than 139, then return false, else return true
            return (newLength > 139) ? false : true
    }
}
