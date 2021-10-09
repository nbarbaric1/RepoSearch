//
//  DetailsViewController.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 07.10.2021..
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var transparentView: UIView!
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    
    // MARK: Properties
    
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repository = repository else {
            return
        }
        configureUI()
        getNameOfUser(for: repository.owner.login)
    }
}

// MARK: Functions

private extension DetailsViewController {
    func configureUI(){
        guard let repository = repository else { return }
        repositoryNameLabel.text = repository.name
        descriptionLabel.text = repository.repositoryDescription == nil ? "No description" : repository.repositoryDescription
        updatedAtLabel.text = repository.updatedAt.replacingOccurrences(of: "Z", with: " ")
                                                  .replacingOccurrences(of: "T", with: " ")
        containerView.makeRoundedTopCorners(withCornerRadius: 20)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func getNameOfUser(for username: String) {
        NetworkController.getUser(with: username) { (error, dataResponse) in
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "An error occured.", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            if let dataResponse = dataResponse {
                DispatchQueue.main.async {
                    self.ownerNameLabel.text = dataResponse.getName()
                }
            }
        }
    }
}
