//
//  PostViewController.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 3/1/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postedLabel: UILabel!
    
    var tweetId: String = ""
    var isReplying: Bool?
    var replyTo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postTextView.delegate = self
        postTextView.text = replyTo
        
        
        let imageUrl = (User.currentUser?.profileImageUrl)!
        profilePicture.setImageWithURL(NSURL(string: imageUrl)!)
        
        postTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onPost(sender: AnyObject) {
        if(isReplying==true)
        {
            TwitterClient.sharedInstance.reply(tweetId, retweetText: postTextView.text)
        }else{
            TwitterClient.sharedInstance.tweet(postTextView.text)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
