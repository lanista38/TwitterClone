//
//  TweetsViewController.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 2/23/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets: [Tweet]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 10
        
        
        
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
        self.tweets = tweets
        self.tweetTableView.reloadData()
        for tweet in tweets {
            print(tweet.text)
        }
        }, failure: { (error:NSError) -> () in
            print(error.localizedDescription)
        })
        
        // Initialize a UIRefreshControl ------> thats the circle for loading and refreshing the app
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
   
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //Connect to the API to have the last update
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetTableView.reloadData()
            }, failure: { (error:NSError) -> () in
                print(error.localizedDescription)
            })
        
        
    
        //update the collection data source
        refreshControl.endRefreshing()
     }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets![indexPath.row]
        //cell.tweetLabel.sizeToFit()
        
        return cell
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

       override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postSegue" {
            
            _ = sender as! UIBarButtonItem
           
            _ = segue.destinationViewController as! PostViewController
            
            
        }
        if segue.identifier == "replySegue" {
            print("started replying")
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tweetTableView)
            if let indexPath = self.tweetTableView.indexPathForRowAtPoint(buttonFrame.origin) {
                let postController = segue.destinationViewController as! PostViewController
                let selectedRow = indexPath.row as NSInteger
                let tweet = tweets![selectedRow]
                
                postController.isReplying = true
                
                postController.tweetId = tweet.tweetId!
                postController.replyTo = "@\((tweet.user?.screenname!)!) " as String
                
            }
        }
        if segue.identifier == "profileSegue" {
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tweetTableView)
            if let indexPath = self.tweetTableView.indexPathForRowAtPoint(buttonFrame.origin) {
                let profileController = segue.destinationViewController as! ProfileViewController
                
               let selectedRow = indexPath.row as NSInteger
                
                profileController.tweets = tweets
                
                profileController.index = selectedRow
                
                tweetTableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            }
    
    if segue.identifier == "singletweetSegue" {
        let cell = sender as! UITableViewCell
            if let indexPath = tweetTableView.indexPathForCell(cell) {
    
                let singeTweetController = segue.destinationViewController as! SingleTweetViewController
    
                let selectedRow = indexPath.row as NSInteger
    
                singeTweetController.tweets = tweets
                singeTweetController.index = selectedRow
    
                tweetTableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            }
    
    }
}


