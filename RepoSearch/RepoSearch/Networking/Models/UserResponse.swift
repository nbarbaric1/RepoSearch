//
//  UserResponse.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 07.10.2021..
//

import Foundation

struct UserResponse: Codable {
    var name: String?
    
    func getName() -> String {
        guard let name = name else {
            return "No name"
        }
        return name
    }
}
