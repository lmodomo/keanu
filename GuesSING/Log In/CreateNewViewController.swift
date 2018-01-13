//
//  CreateNewViewController.swift
//  GuesSING
//
//  Created by Keanu Freitas on 12/8/17.
//  Copyright © 2017 Pashyn Santos LLC. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class CreateNewViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.hideKeyboardWhenTappedOutside()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountBtnTapped(_ sender: Any) {
        if reEnterPasswordTextField.text == passwordTextField.text {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    let errorAlert = UIAlertController(title: "Signup error", message: "\(String(describing: error?.localizedDescription)) Please try again later.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                self.sendEmail()
                self.dismiss(animated: true, completion: nil)
            })
        }else {
            let passwordMatchAlert = UIAlertController(title: "Oops!", message: "Your passwords do not match. Please re-enter your password again.", preferredStyle: .alert)
            passwordMatchAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.passwordTextField.text = ""
                self.reEnterPasswordTextField.text = ""
            }))
            present(passwordMatchAlert, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                let emailNotSentAlert = UIAlertController(title: "Email Verification", message: "Verification Email failed to send: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                emailNotSentAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(emailNotSentAlert, animated: true, completion: nil)
            } else {
                let emailSentAlert = UIAlertController(title: "Email Verification", message: "Verification Email has been sent. Please tap on the link in the email to verify your account before you can use the features in the app. ", preferredStyle: .alert)
                emailSentAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(emailSentAlert, animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
                })
            }
                do {
                    try Auth.auth().signOut()
                } catch {
                    // Doing some error handeling here.
                    
                }
        })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            reEnterPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alreadyAMemberBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "ToLogIn", sender: nil)
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

extension UIViewController {
    
    func hideKeyboardWhenTappedOutside() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
