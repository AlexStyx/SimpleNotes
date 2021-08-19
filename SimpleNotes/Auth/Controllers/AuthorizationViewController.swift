//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak private var warningLabel: UILabel!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var logInButton: UIButton!
    
    private let firebaseService = FirebaseService.shared
    private lazy var scrollViewAndKeyboardHelper = ScrollViewAndKeyboardHelper(scrollView: scrollView, view: view)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        scrollViewAndKeyboardHelper.addKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firebaseService.listenAuthentication { [weak self] in
            self?.performSegue(withIdentifier: SegueIdentifiers.notesSegue, sender: nil)
        }
    }
    
    private func displayWarningMessage(with message: String) {
        warningLabel.text = message
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            [weak self] in
            self?.warningLabel.alpha = 1
        } completion: { [weak self ]complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    @IBAction private func logInButtonTapped(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",
            password != ""
        else {
            displayWarningMessage(with: "Wrong password or email")
            return
        }
        
        firebaseService.logIn(withEmail: email, password: password) { [weak self] userData, error in
            guard
                let userData = userData,
                error == nil
            else {
                self?.displayWarningMessage(with: "Wrong password or email")
                return
            }
            self?.firebaseService.userId = userData.user.uid
        }
        
    }
    
    @IBAction func unwindSegue(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {}
    
    private func setupDesign() {
        emailTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        logInButton.layer.cornerRadius = 15
        warningLabel.alpha = 0
    }
    
}

//MARK: - touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) 
extension AuthorizationViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
    }
}

