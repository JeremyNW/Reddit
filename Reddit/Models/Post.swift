//  Created by Jeremy Warren on 9/3/21.

import Foundation

struct RedditResponse: Codable {
    let data: ResponseData
}

struct ResponseData: Codable {
    let children: [PostData]
}

struct PostData: Codable {
    let data: Post
}

struct Post: Codable {
    let title: String
    let subreddit: String
    let ups: Int
    let downs: Int
    let numComments: Int
}


