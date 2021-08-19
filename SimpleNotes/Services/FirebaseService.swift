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
    
    var userId: String = ""
    
    func createUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func logIn(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listenAuthentication(completion: @escaping ()->()) {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.userId = user.uid
                completion()
            }
        }
    }
    
    func saveUser(userId: String, email: String) {
        let user = User(id: userId, email: email)
        self.userId = userId
        let reference = buildReference(for: .user(userId: userId))
        reference.setValue(user.dataDictionary)
    }
    
    func saveNote(title: String, text: String, date: Date) {
        let reference = buildReference(for: .newNote)
        guard let id = reference.key else { fatalError("no id") }
        let note = Note(id: id, title: title, text: text, date: date)
        reference.setValue(note.dataDict)
    }
    
    func updateNote(note: Note) {
        let reference = note.reference
        reference?.updateChildValues(note.dataDict)
    }
    
    func getNotes(completion: @escaping ([Note]) -> ()) {
        let reference = buildReference(for: .notesList)
        reference.observe(.value) { snapshot in
            var notes = [Note]()
            for child in snapshot.children {
                if
                    let snapshot = child as? DataSnapshot,
                    let note = Note(snaphsot: snapshot) {
                    notes.append(note)
                    completion(notes)
                }
            }
        }
    }
    
    private func buildReference(for type: refType) -> DatabaseReference {
        let reference = ref
        switch type {
        case .user(let id):
            return reference.child("users").child(id)
        case .existedNote(let noteId):
            return reference.child("users").child(userId).child("notes").child(noteId)
        case .newNote:
            return reference.child("users").child(userId).child("notes").childByAutoId()
        case .notesList :
            return reference.child("users").child(userId).child("notes")
        }
    }
    
    enum refType {
        case user(userId: String)
        case existedNote(noteId: String)
        case newNote
        case notesList
    }
}

