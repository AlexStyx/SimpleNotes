//
//  NoteTableViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainTextView: UITextView!
    
    override func viewDidLoad() {
        if let note = note {
            titleTextField.text = note.title
            mainTextView.text = note.text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        saveNote()
    }
    
    private func saveNote() {
        guard
            let title = titleTextField.text,
            let text = mainTextView.text,
            title != "",
            text != ""
        else {
            return
        }
        FirebaseService.shared.saveNote(title: title, text: text, date: Date())
    }
    
    

}
