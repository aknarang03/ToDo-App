//
//  RegisterViewController.swift
//  ToDo App
//
//  Created by Anjali Narang  on 11/7/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    let userModel = UserModel.shared

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        register()
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func register () {
        
        Task {
                
            if let enteredUsername = username.text,
               let enteredEmail = email.text,
               let enteredPassword = password.text,
               let enteredPhoneNumber = phone.text {
                
                let (result, resultMessage) = try await userModel.registerAsync(
                    withEmail: enteredEmail,
                    password: enteredPassword,
                    andUsername:enteredUsername,
                    andPhoneNumber: enteredPhoneNumber
                )
            
                if result { // REGISTER SUCCEEDED
                    print (resultMessage)
                    print (userModel.authorizedUser!.uid)
                    let alert = UIAlertController(title: "Register",
                                              message: "Register successful",
                                              preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            
                else { // REGISTER FAILED
                    print (resultMessage)
                    let alert = UIAlertController(title: "Register failed",
                                                  message: resultMessage,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            
            }
            
            else { // CREDENTIALS NOT ENTERED PROPERLY
                let alert = UIAlertController(title: "Register",
                                          message: "Enter credentials",
                                          preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        
        }
    
    }
    
}
