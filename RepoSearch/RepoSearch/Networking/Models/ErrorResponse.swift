//
//  ErrorResponse.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 07.10.2021..
//
import Foundation

struct ErrorResponse: Codable {
    let message: String
    let documentationURL: String

    enum CodingKeys: String, CodingKey {
        case message
        case documentationURL = "documentation_url"
    }
}
