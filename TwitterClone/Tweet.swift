//
//  Tweet.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 2/22/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var screenName: String?
    var text: NSString?
    var timestamp: NSDate?
    var tweetId: String?
    var retweetCount: Int = 0
    var favoritesCount: String?
    var readDate: NSTimeInterval?
    var favoriteStatus: Bool?
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        screenName = dictionary["screenname"] as? String
        text = dictionary["text"] as? String
        tweetId = (dictionary["id_str"] as! String?)!
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteStatus = dictionary["favorited"] as? Bool
        favoritesCount = "\((dictionary["favorite_count"])!)"
        
        let timestampString = dictionary["created_at"] as? String
        
        
        if let timestampString = timestampString {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
           readDate = timestamp?.timeIntervalSinceNow
            
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets;
    }
   static func stringFromTimeInterval(interval:NSTimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
        
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        if(-hours > 0)
        {
            return String(format: "%0.2d" + "h", -hours)
        } else if(-minutes > 0)
        {
            return String(format: "%0.2d" + "m", -minutes)
        } else
        {
        return String(format: "%0.2d" + "s", -seconds)
        }
    
    
    
    }
}
