//
//  NoteCell.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit

class NoteCell: UITableViewCell {

    var viewModel: NoteCellViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }
            headerLabel.text = viewModel.title
            noteTextLabel.text = viewModel.text
            dateLabel.text = viewModel.dateString
            
        }
    }
    
    @IBOutlet weak private var headerLabel: UILabel!
    @IBOutlet weak private var noteTextLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
}
