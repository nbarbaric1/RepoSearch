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
    @IBOutlet private weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var results: [Repository] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - Functions

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
    
    func getRepository(for input: String) {
        self.loadingActivityIndicatorView.startAnimating()
        NetworkController.getRepositories(with: input) { (error, dataResponse) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.loadingActivityIndicatorView.stopAnimating()
                    let alert = UIAlertController(title: "An error occured.", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            if let dataResponse = dataResponse {
                DispatchQueue.main.async {
                    self.results = dataResponse.repositories
                    self.loadingActivityIndicatorView.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - SearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchViewController.reload), object: nil)
        self.perform(#selector(SearchViewController.reload), with: nil, afterDelay: 0.8)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
        
    @objc func reload() {
        search()
    }
    
    func search() {
        guard let searchText = searchBar.text else { return }
        let input = searchText.trimmingCharacters(in: .whitespaces)
        if !input.isEmpty {
            getRepository(for: input)
        }
    }
}

// MARK: - TableView DataSource, Delegate

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count == 0 ? 1 : results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if results.count == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No results. Try something different."
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryTableViewCell.self), for: indexPath) as! RepositoryTableViewCell
        cell.configureCell(with: results[indexPath.row])
        return cell
    }
}
