//
//  RepositoryResponse.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 07.10.2021..
//

import Foundation

// MARK: - RepositoryResponse
struct RepositoryResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let repositories: [Repository]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repositories = "items"
    }
}

// MARK: - Repository
struct Repository: Codable {
    let name, fullName: String
    let owner: Owner
    let repositoryDescription: String?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case owner
        case repositoryDescription = "description"
        case updatedAt = "updated_at"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String

    enum CodingKeys: String, CodingKey {
        case login
    }
}
