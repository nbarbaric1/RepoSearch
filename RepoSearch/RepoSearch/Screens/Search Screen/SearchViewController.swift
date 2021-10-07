//
//  ViewController.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 07.10.2021..
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var resultsTableView: UITableView!
    
    // MARK: - Properties
    
    private var results: [Repository] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension SearchViewController {
    func configureUI() {
        configureSearchBar()
        configureResultsTableView()
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = true
        
    }
    
    func configureResultsTableView() {
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self), for: indexPath) as! RepositoryTableViewCell
        cell.configureCell(with: repositories[indexPath.row])
        return cell
    }
    
    
}

