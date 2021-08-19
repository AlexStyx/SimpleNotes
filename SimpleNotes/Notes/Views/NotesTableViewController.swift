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
        willSet(viewModel) {
            viewModel.onCompletion = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        signOut()
    }
    
    private var isSearchBarEmpty: Bool {
        guard let text = navigationItem.searchController?.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isSearching: Bool {
        (navigationItem.searchController?.isActive ?? false) && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }

    private func signOut() {
        let signOutAlertController = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            FirebaseService.shared.signOut()
            self?.performSegue(withIdentifier: SegueIdentifiers.unwindToAuth, sender: nil)
        }
        
        signOutAlertController.addAction(cancelAction)
        signOutAlertController.addAction(confirmAction)
        
        present(signOutAlertController, animated: true)
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

extension NotesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.isSearching = isSearching
        viewModel.filterNotes(searchText)
    }
}

extension NotesTableViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
