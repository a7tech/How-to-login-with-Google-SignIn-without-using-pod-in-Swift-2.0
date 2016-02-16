//
//  ViewController.swift
//  GoogleSignInSwift
//
//  Created by mac on 16/02/16.
//  Copyright © 2016 Inwizards. All rights reserved.
//

import UIKit

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var statusText: UILabel!
    
    @IBOutlet weak var NameText: UILabel!
    
    @IBOutlet weak var EmailText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "receiveToggleAuthUINotification:",name: "ToggleAuthUINotification",object: nil)
        
        statusText.text = "Initialized Swift app..."
        
        toggleAuthUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func didTapSignOut(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signOut()
        
        statusText.text = "Signed out."
        
        toggleAuthUI()
    }
    
    @IBAction func didTapDisconnect(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().disconnect()
        
        statusText.text = "Disconnecting."
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        if (error == nil) {
            
            let userId = user.userID
            
            let name = user.profile.name
            
            let email = user.profile.email
           
            print(userId)
            
            NameText.text = NSString(format: "Name: %@", name) as String
            
            EmailText.text = NSString(format: "Email ID: %@", email) as String
            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleAuthUINotification",object: nil,userInfo: ["statusText": "Signed in Successfully"])
        } else {
            print("\(error.localizedDescription)")
            
            NSNotificationCenter.defaultCenter().postNotificationName("ToggleAuthUINotification", object: nil, userInfo: nil)
        }
    }
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("ToggleAuthUINotification",object: nil,userInfo: ["statusText": "User has disconnected."])
    }
    // [START toggle_auth]
    func toggleAuthUI() {
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()){
            // Signed in
            signInButton.hidden = true
            signOutButton.hidden = false
            disconnectButton.hidden = false
        } else {
            signInButton.hidden = false
            signOutButton.hidden = true
            disconnectButton.hidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: "ToggleAuthUINotification",
            object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        if (notification.name == "ToggleAuthUINotification") {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                let userInfo:Dictionary<String,String!> =
                notification.userInfo as! Dictionary<String,String!>
                self.statusText.text = userInfo["statusText"]
            }
        }
    }
}

