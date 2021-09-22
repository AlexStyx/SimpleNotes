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
    private let firebaseService = FirebaseService.shared
    
    private lazy var scrollViewAndKeyboardHelper = ScrollViewAndKeyboardHelper(scrollView: scrollView, view: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        scrollViewAndKeyboardHelper.addKeyboardNotifications()
    }

    @IBAction private func signUpButtonPressed(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatedPassword = repeatPasswordTextField.text,
            email != "",
            password != "",
            password == repeatedPassword
        else {
            displayWarningMessage(errorType: .passwordMismatch)
            return
        }
        
        firebaseService.createUser(withEmail: email, password: password) { [weak self] in
            self?.performSegue(withIdentifier: SegueIdentifiers.notesSegue, sender: nil)
        } warningCompletion: { [weak self] in
            self?.displayWarningMessage(errorType: .incorrectInput)
        }

    }
    
    private func displayWarningMessage(errorType: AuthErrorType) {
        var message: String
        switch errorType {
        case .incorrectInput:
            message = "Input incorrect password or email"
        case .passwordMismatch:
            message = "Password missmatch"
        case .serverError:
            message = "Server error"
        }
        warningLabel.text = message
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            [weak self] in
            self?.warningLabel.alpha = 1
        } completion: { [weak self ]complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    private func setupDesign() {
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        warningLabel.alpha = 0
    }

}
