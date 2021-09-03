//
//  PostManager.swift
//  Reddit
//
//  Created by Jeremy Warren on 9/3/21.
//

import Foundation

protocol PostManagerDelegate {
    func didFetchData(posts: [Post])
    func didFail(error: Error?)
    
}

struct PostManager {
    
    var delegate: PostManagerDelegate?
    
    func fetchPost(for subreddit: String) {
        
        // URL - https://www.reddit.com/r/{subreddit}.json
        guard var url = URL(string: "https://www.reddit.com/r/") else {
            delegate?.didFail(error: nil)
            return
        }
        
        url.appendPathComponent(subreddit)
        url.appendPathExtension("json")
        
        // Request
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            
            // Error
            if let error = error {
                delegate?.didFail(error: error)
                return
            }
            
            // Data
            guard let data = data else {
                delegate?.didFail(error: nil)
                return
            }
            
            // Decode
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(RedditResponse.self, from: data)
                let posts = response.data.children.map { $0.data }
                delegate?.didFetchData(posts: posts)
            } catch {
                delegate?.didFail(error: error)
                return
            }
            
        }.resume()
    }
}
