//
//  FirebaseService.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseService {

    private var ref = Database.database().reference()
    private init () {}

    static let shared = FirebaseService()

    func createUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func logIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func saveUser(userId: String, email: String) {
        let user = User(id: userId, email: email)
        let reference = ref.child("users").child(userId)
        reference.setValue(user.dataDictionary)
    }
    
    func listenAuthentication(completion: @escaping ()->()) {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
               completion()
            }
        }
    }
}

