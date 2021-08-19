//
//  RegistrationViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak private var warningLabel: UILabel!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak private var signUpButton: UIButton!
    
    private lazy var scrollViewAndKeyboardHelper = ScrollViewAndKeyboardHelper(scrollView: scrollView, view: view)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        scrollViewAndKeyboardHelper.addKeyboardNotifications()
    }

    @IBAction private func signUpButtonPressed(_ sender: UIButton) {
        let firebaseService = FirebaseService.shared
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatedPassword = repeatPasswordTextField.text,
            email != "",
            password != "",
            password == repeatedPassword
        else {
            return
        }
        
        firebaseService.createUser(withEmail: email, password: password) { [weak self] userData, error in
            guard
                let userData = userData,
                error == nil
            else {
                return
            }
            let userId = userData.user.uid
            firebaseService.saveUser(userId: userId, email: email)
            self?.performSegue(withIdentifier: SegueIdentifiers.notesSegue, sender: nil)
        }
    }
    
    private func setupDesign() {
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        warningLabel.alpha = 0
    }

}
