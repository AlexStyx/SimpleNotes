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
    
    var onCompletion: (()->())?
    
    private var notes: [Note] = [] {
        didSet {
            onCompletion?()
        }
    }
    
    func noteCellViewModel(for indexPath: IndexPath) -> NoteCellViewModelProtocol {
        let note = notes[indexPath.row]
        let noteCellViewModel = NoteCellViewModel(note: note)
        return noteCellViewModel
    }
    
    func numberOfRows() -> Int {
        return notes.count
    }
    
    func note(for indexPath: IndexPath) -> Note {
        return notes[indexPath.row]
    }
    
    override init() {
        super.init()
        FirebaseService.shared.getNotes { [weak self] notes in
            self?.notes = notes.sorted { $0.date < $1.date }
        }
    }
}
