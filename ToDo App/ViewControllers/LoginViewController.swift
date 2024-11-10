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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    let userModel = UserModel.shared

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginButtonPress(_ sender: Any) {
        login()
    }
    @IBAction func registerButtonPress(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
        
    func login () {
        
        print("login button press")
        
        Task {
            
            if let enteredEmail = email.text, let enteredPassword = password.text {
                
                let (result, resultMessage) = try await userModel.signInAsync(withEmail: enteredEmail, andPassword: enteredPassword)
                
                if result { // LOGIN SUCCEEDED
                    performSegue(withIdentifier: "loginSegue", sender: self)
                }
                
                else { // LOGIN FAILED
                    let alert = UIAlertController(title: "Login Failed",
                                                  message: "Error: \(resultMessage)",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else { // CREDENTIALS NOT ENTERED PROPERLY
                let alert = UIAlertController(title: "Login",
                                              message: "Please enter credentials",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }

}
