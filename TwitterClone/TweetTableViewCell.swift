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
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
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
            
            let imageUrl = tweet.user!.profileImageUrl
            
            profilePic.setImageWithURL((NSURL( string: imageUrl!)!))
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
    
    @IBAction func onFavorite(sender: AnyObject) {

         favoriteStatus = tweet.favoriteStatus
        TwitterClient.sharedInstance.favorites(tweet.tweetId!, isFavorited: favoriteStatus!)
        favoritesCountLabel.reloadInputViews()
    }
}