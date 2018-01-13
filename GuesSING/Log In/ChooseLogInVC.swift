//
//  ChooseLogInVC.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/8/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FacebookCore

class ChooseLogInVC: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonSetup()
        
        // Log out authentication for user from Firebase.
        if Auth.auth().currentUser != nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarNav") as! UITabBarController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBarController
            tabBarController.selectedIndex = 1
        }
        
        // Creating the Facebook Log-In button.
        let fbLogInBtn = FBSDKLoginButton()
        view.addSubview(fbLogInBtn)
        fbLogInBtn.layer.cornerRadius = 8
        fbLogInBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Creating the contraints for the FAcebook log-in button.
        let horizontal = NSLayoutConstraint(item: fbLogInBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0.0)
        let vertical = NSLayoutConstraint(item: fbLogInBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.65, constant: 0.0)
        let width = NSLayoutConstraint(item: fbLogInBtn, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.74, constant: 0.0)
        let height = NSLayoutConstraint(item: fbLogInBtn, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.05, constant: 0.0)
        
        // Add the contraints.
        view.addConstraints([horizontal, vertical, width, height])
        fbLogInBtn.delegate = self
        fbLogInBtn.readPermissions = ["email", "public_profile"]
    }
    
    func buttonSetup() {
        
        // Setting up the buttons.
        loginBtn.backgroundColor = UIColor.white
        loginBtn.layer.cornerRadius = 8
        
        signupBtn.backgroundColor = UIColor.white
        signupBtn.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        // Log-out function for Firebase.  With an error to let me know if there was a problem logging out.
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("Did log out of Facebook.")
        
        // Go to the Login Screen when the user logs out.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = storyBoard.instantiateViewController(withIdentifier: "CreateVC") as! ChooseLogInVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = createVC
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        // Log-In function for Firebase.
        if error != nil {
            print("error")
            return
        }
        // Get this information from the user and add to Firebase.  This info is taken from the users Facebook account.
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, results, error) in
            if error != nil {
                print("failed")
                return
            }
            // Use the access token for logging in.
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else
            { return }
            
            // Allow the user to authenticate with the access token.
            // This is for better security.
            let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            // Creating the User in Firebase using the Uid and token from Facebook.
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                let databaseRef = Database.database().reference()
                databaseRef.child("users").updateChildValues(["uid" : user?.uid as Any])
                
                if error != nil {
                    print("Error!")
                    return
                }
            })
            
            // When logged in, go to specified view.
            DispatchQueue.main.async {
                // The main screen after log-in is the mapview, which is at tab index 2.
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarNav") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
