//
//  AuthErrorType.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/20/21.
//

import Foundation

enum AuthErrorType: String {
    case incorrectInput = "Wrong email or password"
    case passwordMismatch = "Password does not match"
    case serverError = "Server error"
}
