//
//  LogInViewController.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/8/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedOutside()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInBtnTapped(_ sender: Any) {
        // Allow the user to Log In with username and password, but first checking Firebase.
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                let logInErrorAlert = UIAlertController(title: "Login Error!", message: "\(String(describing: error?.localizedDescription)): Please try again.", preferredStyle: .alert)
                logInErrorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(logInErrorAlert, animated: true, completion: nil)
                return
            }
            if user!.isEmailVerified {
                // Take user to Firebase Realtime Database
               //self.performSegue(withIdentifier: "ToMainTabBarController", sender: self)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarNav") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = tabBarController
                tabBarController.selectedIndex = 1
            } else {
                let notVerifiedEmailAlert = UIAlertController(title: "Not verified!", message: "Your account is pending verification. Please check your email and verify your account.", preferredStyle: .alert)
                notVerifiedEmailAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(notVerifiedEmailAlert, animated: true, completion: nil)
                
                do {
                    try Auth.auth().signOut()
                } catch {
                    // Error handle
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        // Dismiss the page back to the Choose Log In View Controller.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        // This is where I will have the user taken to the forgot password page.
        let forgotPasswordAlert = UIAlertController(title: "Forgot Password?", message: "Don't worry. We will send you an email so that you can reset it. Enter your email address here.", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter your email address."
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text

            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed!", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                } else {
                    let resetEmailWasSent = UIAlertController(title: "Reset email sent", message: "A password reset email has been sent to your registered email address successfully. Please check your email for further password reset intructions.", preferredStyle: .alert)
                    resetEmailWasSent.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(resetEmailWasSent, animated: true, completion: nil)
                    
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        // Error Handle
                    }
                }
            })
        }))
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
