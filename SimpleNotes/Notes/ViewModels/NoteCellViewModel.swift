//
//  NoteCellViewModel.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import Foundation

protocol NoteCellViewModelProtocol {
    var title: String { get }
    var text: String { get }
    var dateString: String { get }
}

class NoteCellViewModel: NSObject, NoteCellViewModelProtocol {
    
    private var note: Note
    
    var title: String {
        note.title
    }
    
    var text: String {
        note.text
    }
    
    var dateString: String {
        note.dateString
    }
    
    init(note: Note) {
        self.note = note
    }
}


