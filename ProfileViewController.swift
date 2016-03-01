//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 2/29/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate{

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var screennameVar: String = ""
    var tweets: [Tweet]?
    var user: User?
    var index: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tweet = tweets![index!]
        nameLabel.text = (tweet.user?.name)!
        screennameVar = (tweet.user?.screenname)!
        userDescriptionLabel.text = (tweet.user?.tagline)!
        usernameLabel.text = "@\((tweet.user?.screenname)!)"
        numTweetsLabel.text = "Tweets: \((tweet.user?.numtweetsCount)!)"
        numFollowingLabel.text = "Following: \((tweet.user?.numfollowerCount)!)"
        numFollowersLabel.text = "Follorwers: \((tweet.user?.numfollowingCount)!)"
        
        let imageUrl = tweet.user?.profileImageUrl!
        profileImageView.setImageWithURL(NSURL(string: imageUrl!)!)
        
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 120
        
       getTweets() 
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
        
        cell.tweetLabel.sizeToFit()
        
        return cell
    }
    func getTweets() {
        TwitterClient.sharedInstance.userTimeline(screennameVar) { (tweets, error) -> () in
            self.tweets = tweets
            self.profileTableView.reloadData()
        }
    }
    
    /**
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "profileSegue" {
            let cell = sender as! TweetTableViewCell
            let indexPath = profileTableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let tweetdetailViewController = segue.destinationViewController as! TweetsViewController
            
        }
**/
    
    

}
