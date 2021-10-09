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
    private var numberOfPages: Int = 1
    private var currentPage: Int = 1
    
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
        resultsTableView.alwaysBounceVertical = false
    }
    
    func getRepository(for input: String) {
        self.loadingActivityIndicatorView.startAnimating()
        NetworkController.getRepositories(with: input, page: currentPage) { (error, dataResponse) in
            
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
                    let numberOfPages = (dataResponse.totalCount / 30) == 0 ? 1 : dataResponse.totalCount / 30
                    self.numberOfPages = (dataResponse.totalCount % 30 ) == 0 ? numberOfPages : numberOfPages + 1
                    self.results.append(contentsOf: dataResponse.repositories)
                    self.loadingActivityIndicatorView.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        }
    }
    
    func navigateToDetailsScreen(for repository: Repository){
        let nextScreen = "Details"
        let storyboard = UIStoryboard(name: nextScreen, bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: String( nextScreen + "ViewController")) as! DetailsViewController
        nextViewController.repository = repository
        navigationController?.present(nextViewController, animated: true, completion: nil)
    }
}

// MARK: - SearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchViewController.reload), object: nil)
        self.perform(#selector(SearchViewController.reload), with: nil, afterDelay: 0.8)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        results = []
        currentPage = 1
        numberOfPages = 1
        search()
    }
        
    @objc func reload() {
        results = []
        currentPage = 1
        numberOfPages = 1
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToDetailsScreen(for: results[indexPath.row])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == resultsTableView {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                print("sapasad")
                currentPage < numberOfPages ? currentPage = currentPage + 1 : ()
                search()
            }
        }
    }
    
    
}
