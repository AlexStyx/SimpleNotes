//
//  RegistrationViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class RegistrationViewController: UIViewController {


    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
    }

    @IBAction private func signUpButtonPressed(_ sender: UIButton) {
        let firebaseService = FirebaseService.shared
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",
            password != ""
        else {
            displayWarningMessage()
            return
        }
        
        firebaseService.createUser(withEmail: email, password: password) { [weak self] userData, error in
            guard
                let userData = userData,
                error == nil
            else {
                self?.displayWarningMessage()
                return
            }
            let userId = userData.user.uid
            firebaseService.saveUser(userId: userId, email: email)
            self?.performSegue(withIdentifier: SegueIdentifiers.notesSegue, sender: nil)
        }
    }
    
    private func displayWarningMessage() {
        
    }
    
    private func setupDesign() {
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        warningLabel.alpha = 0
    }

}
