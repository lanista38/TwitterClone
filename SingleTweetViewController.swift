//
//  SingleTweetViewController.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 3/3/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoritesGrayHeart: UIButton!
    var tweets: [Tweet]?
    var index: Int?
    var tweet : Tweet?
    
    var dateString: String?
    var favoriteStatus: Bool?
    var favoritesCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweet = tweets![index!]
        nameLabel.text = (tweet!.user?.name)!
        tweetLabel.text = tweet!.text as? String
        usernameLabel.text = "@\((tweet!.user?.screenname)!)"
        
        dateString = Tweet.stringFromTimeInterval(tweet!.readDate!)
        
        timeStampLabel.text = "\(dateString!)"
        
        favoritesCount = Int(tweet!.favoritesCount!)
        favoritesCountLabel.text = tweet!.favoritesCount!
        let imageUrl = tweet!.user!.profileImageUrl!
        
        profilePic.setImageWithURL((NSURL( string: imageUrl)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        favoriteStatus = tweet!.favoriteStatus
        if((favoriteStatus) == false)
        {
            favoritesGrayHeart.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
            favoritesCount = favoritesCount! + 1
        }
        favoritesCountLabel.text = "\(favoritesCount!)"
            TwitterClient.sharedInstance.favorites(tweet!.tweetId!, isFavorited: favoriteStatus!)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
