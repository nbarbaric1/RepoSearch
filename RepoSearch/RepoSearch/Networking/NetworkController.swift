import Foundation

struct NetworkController {
    
    static func getRepositories(with input: String, completionBlock: @escaping (String?, RepositoryResponse?) -> Void) {
        
        let query = "?q=" + input.replacingOccurrences(of: " ", with: "+")
        let url = URLPath.base.rawValue + URLPath.searchRepositoresPath.rawValue + query + URLPath.sort.rawValue + URLPath.order.rawValue
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("token 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", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let message = "There was a problem with your network request: \(error)"
                completionBlock(message, nil)
                return
            }
            
            if let data = data {
                do {
                    let repoResponse = try JSONDecoder().decode(RepositoryResponse.self, from: data)
                    completionBlock(nil, repoResponse)
                }
                catch _ {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completionBlock(errorResponse.message, nil)
                    }
                    catch let error2 {
                        let message = "Failed to parse a network response. Check your input and network connection. \(error2)"
                        completionBlock(message, nil)
                    }
                }
            }
        }.resume()
    }
    
    static func getUser(with username: String, completionBlock: @escaping (String?, UserResponse?) -> Void) {
        
        let query = "/" + username.replacingOccurrences(of: " ", with: "")
        let url = URLPath.base.rawValue + URLPath.usersPath.rawValue + query
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("token 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", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                let message = "There was a problem with your network request: \(error)"
                completionBlock(message, nil)
                return
            }
            
            if let data = data {
                do {
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    completionBlock(nil, userResponse)
                }
                catch _ {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        completionBlock(errorResponse.message, nil)
                    }
                    catch let error2 {
                        let message = "Failed to parse a network response. Check your input and network connection. \(error2)"
                        completionBlock(message, nil)
                    }
                }
            }
        }.resume()
    }
}

enum URLPath: String {
    case base = "https://api.github.com"
    case searchRepositoresPath = "/search/repositories"
    case usersPath = "/users"
    case sort = "&sort=updated"
    case order = "&order=desc"
}
