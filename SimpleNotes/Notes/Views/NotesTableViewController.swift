//
//  NotesTableViewController.swift
//  SimpleNotes
//
//  Created by Александр Бисеров on 8/2/21.
//

import UIKit
import Firebase

class NotesTableViewController: UITableViewController {
    
    @IBOutlet var viewModel: NotesTableViewViewModel! {
        willSet {
            newValue.onCompletion = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let noteCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? NoteCell else { fatalError() }
        noteCell.viewModel = viewModel.noteCellViewModel(for: indexPath)
        return noteCell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = viewModel.note(for: indexPath)
            note.reference?.removeValue()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == SegueIdentifiers.openNoteSegue,
            let noteViewController = segue.destination as? NoteTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let note = viewModel.note(for: indexPath)
            noteViewController.note = note
            noteViewController.usageCase = .editing
        }
    }
}

