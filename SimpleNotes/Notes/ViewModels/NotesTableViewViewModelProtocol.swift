//
//  NotesViewModel.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import Foundation

protocol NotesTableViewViewModelProtocol {
    func noteCellViewModel(for indexPath: IndexPath) -> NoteCellViewModelProtocol
    func numberOfRows() -> Int
}

class NotesTableViewViewModel: NSObject, NotesTableViewViewModelProtocol {
    private var notes: [Note]
    
    func noteCellViewModel(for indexPath: IndexPath) -> NoteCellViewModelProtocol {
        updateNotes()
        let note = notes[indexPath.row]
        let noteCellViewModel = NoteCellViewModel(note: note)
        return noteCellViewModel
    }
    
    func numberOfRows() -> Int {
        updateNotes()
        return notes.count
    }
    
    func note(for indexPath: IndexPath) -> Note {
        updateNotes()
        return notes[indexPath.row]
    }
    
    override init() {
        notes = FirebaseService.shared.getNotes()
        super.init()
    }
    
    private func updateNotes() {
        notes = FirebaseService.shared.getNotes()
    }
    
}
