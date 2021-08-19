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
    func filterNotes(_ searchText: String)
}
class NotesTableViewViewModel: NSObject, NotesTableViewViewModelProtocol {
        
    var onCompletion: (()->())?
    
    var isSearching = false
    
    private var notes = [Note]() {
        didSet {
            onCompletion?()
        }
    }
    
    private var filteredNotes = [Note]() {
        didSet {
            onCompletion?()
        }
    }

    func noteCellViewModel(for indexPath: IndexPath) -> NoteCellViewModelProtocol {
        let note = isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
        let noteCellViewModel = NoteCellViewModel(note: note)
        return noteCellViewModel
    }
    
    func numberOfRows() -> Int {
        isSearching ? filteredNotes.count : notes.count
    }
    
    func note(for indexPath: IndexPath) -> Note {
        isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
    }
    
    func filterNotes(_ searchText: String) {
        filteredNotes = notes.filter {
            $0.title.lowercased().contains(searchText.lowercased()) || $0.text.lowercased().contains(searchText.lowercased())
        }
    }
    
    override init() {
        super.init()
        FirebaseService.shared.getNotes { [weak self] notes in
            self?.notes = notes.sorted { $0.date < $1.date }
        }
    }
}
