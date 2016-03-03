//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 2/23/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var likeHeartImageView: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    
    @IBOutlet weak var retweetImageView: UIButton!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    var favoritesCount: Int?
    var reTweetCount: Int?
    var dateString: String?
    var favoriteStatus: Bool?
    var tweet: Tweet! {
        didSet {
            
            nameLabel.text = (tweet.user?.name)!
            tweetLabel.text = tweet.text as? String
            usernameLabel.text = "@\((tweet.user?.screenname)!)"
            
            dateString = Tweet.stringFromTimeInterval(tweet.readDate!)
           
            timeStampLabel.text = "\(dateString!)"
            favoritesCountLabel.text = tweet.favoritesCount 
            favoritesCount = Int(tweet!.favoritesCount!)
            
            reTweetCount = tweet!.retweetCount
            retweetCount.text = String(tweet.retweetCount)
            
            let imageUrl = tweet.user!.profileImageUrl!
            
            profilePic.setImageWithURL((NSURL( string: imageUrl)!))
        }
    }
    
   override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.layer.cornerRadius = 4
        profilePic.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        reTweetCount = reTweetCount! + 1
        retweetCount.text = String (reTweetCount!)
        retweetImageView.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
        TwitterClient.sharedInstance.retweet(tweet.tweetId!)
    }
    @IBAction func onFavorite(sender: AnyObject) {

         favoriteStatus = tweet.favoriteStatus
       
        if((favoriteStatus) == false)
        {
            likeHeartImageView.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
            favoritesCount = favoritesCount! + 1
        }
        TwitterClient.sharedInstance.favorites(tweet.tweetId!, isFavorited: favoriteStatus!)
        
        
    }
}