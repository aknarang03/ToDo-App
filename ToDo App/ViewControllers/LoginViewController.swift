//
//  LoginViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/7/24.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let userModel = UserModel.shared

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginButtonPress(_ sender: Any) {
        login()
    }
    @IBAction func registerButtonPress(_ sender: Any) {
        // NAVIGATE TO REGISTER PAGE
    }
    
    // SIGN IN BUTTON FUNCTION
    
    func login () {
        
        Task {
            
            if let enteredEmail = email.text, let enteredPassword = password.text {
                
                let (result, resultMessage) = try await userModel.signInAsync(withEmail: enteredEmail, andPassword: enteredPassword)
                
                if result { // LOGIN SUCCEEDED
                    //performSegue(withIdentifier: "mainSegue", sender: self)
                    // NAVIGATE TO MAIN PAGE
                }
                
                else { // LOGIN FAILED
                    let alert = UIAlertController(title: "Login Failed",
                                                  message: resultMessage,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else { // CREDENTIALS NOT ENTERED PROPERLY
                let alert = UIAlertController(title: "Login",
                                              message: "Enter Credentials",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }

}