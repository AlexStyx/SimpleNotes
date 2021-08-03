// 
//  NoteTableViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    var note: Note?
    var usageCase: UsageCase = .creating
    
    @IBOutlet weak private var titleTextField: UITextField!
    @IBOutlet weak private var mainTextView: UITextView!
    
    override func viewDidLoad() {
        if let note = note {
            titleTextField.text = note.title
            mainTextView.text = note.text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        switch usageCase {
        case .creating: saveNote()
        case .editing: updateNote()
        }
    }
    
    private func saveNote() {
        guard let titleAndText = checkTextFieldAndTextView() else { return }
        let title = titleAndText.title
        let text = titleAndText.text
        FirebaseService.shared.saveNote(title: title, text: text, date: Date())
    }
    
    
    private func updateNote() {
        guard let titleAndText = checkTextFieldAndTextView(),
              var note = note
        else { return }
        let title = titleAndText.title
        let text = titleAndText.text
        note.title = title
        note.text = text
        note.date = Date()
        FirebaseService.shared.updateNote(note: note)
    }
    
    private func checkTextFieldAndTextView() -> (title: String, text: String)? {
        guard
            let title = titleTextField.text,
            let text = mainTextView.text,
            title != "",
            text != ""
        else {
            return nil
        }
        return (title, text)
    }
    
    enum UsageCase {
        case creating
        case editing
    }
}
