//
//  TwitterClient.swift
//  TwitterClone
//
//  Created by Jorge Cruz on 2/22/16.
//  Copyright © 2016 Jorge Cruz. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let userDidLogOutNotification = "UserdidLogOut"
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "7KSDLfx1lzaNR8MoVHdHCOWUv", consumerSecret: "ySx0MQ6pAZG5PkQardgujFCRSkM5YLKg9RXdjJlrpFZbWNkyni")
    
    var loginSuccess: (() -> ())?
    
    var loginFailure: ((NSError) -> ())?
    
  
    
    func login(success: () -> (), failure: (NSError) -> ())
    {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterClone://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogOutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL)
    {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken!, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as![NSDictionary]
            
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error:NSError) -> Void in
                failure(error)
        })
        
    }
    func userTimeline(screenname: String, completion: (tweet: [Tweet]?, error: NSError?)-> ()) {
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweet: tweets, error: nil)
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Error retrieving info: \(error)")
                
                completion(tweet: nil, error: error)
                
        })
        
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) -> Void in
           
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
                
        })

    }
    
    func tweet(tweetText: String) {
        let escapedText = (tweetText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))!
        POST("1.1/statuses/update.json?status=\(escapedText)", parameters: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("You tweeted!!")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Reply error:\(error)")
        })
        
    }
    
    func favorites(id: String, isFavorited: Bool)
    {
        
        if(!isFavorited){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Favorite +1")
            
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                 print("Favorite not Succesful")
        }
        } else if(isFavorited ){
            POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Favorite -1")
                
                }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("unFavorite not Succesful")
            }

        }
        
        
    }
}
