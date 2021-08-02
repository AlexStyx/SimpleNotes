//
//  User.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import Foundation

struct User {
    let id: String
    let email: String
    
    var dataDictionary: [String: Any] {
        [JSONKeys.id: id, JSONKeys.email: email]
    }
    
    struct JSONKeys {
        static let id = "id"
        static let email = "email"
    }
}
