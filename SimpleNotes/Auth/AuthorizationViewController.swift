//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak private var warningLabel: UILabel!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        let firebaseService = FirebaseService.shared
        firebaseService.listenAuthentication { [weak self] in
            self?.performSegue(withIdentifier: SegueIdentifiers.notesSegue, sender: nil)
        }
    }
    
    private func displayWarningMessage() {
        
    }

    @IBAction private func logInButtonTapped(_ sender: UIButton) {
        print("[ressed")
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",
            password != ""
        else {
            displayWarningMessage()
            return
        }
        
        let firebaseService = FirebaseService.shared
        
        firebaseService.logIn(withEmail: email, password: password) { [weak self] userData, error in
            guard
                let userData = userData,
                error == nil
            else {
                self?.displayWarningMessage()
                print("error occured")
                return
            }
            
            self?.performSegue(withIdentifier: SegueIdentifiers.notesSegue, sender: nil)
        }
        
    }
    
    
    private func setupDesign() {
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        logInButton.layer.cornerRadius = 15
        warningLabel.alpha = 0
    }
    
}

