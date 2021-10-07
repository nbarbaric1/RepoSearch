//
//  RepositoryTableViewCell.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 07.10.2021..
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    
    override func prepareForReuse() {
        repositoryNameLabel.text = ""
        updatedAtLabel.text = ""
        ownerNameLabel.text = ""
    }
    
    func configureCell(with repository: Repository) {
        repositoryNameLabel.text = repository.name
        updatedAtLabel.text = repository.updatedAt.replacingOccurrences(of: "T", with: " ")
                                                  .replacingOccurrences(of: "Z", with: " ")
        ownerNameLabel.text = repository.owner.login
    }
}
