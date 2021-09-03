//
//  TableViewController.swift
//  Reddit
//
//  Created by Jeremy Warren on 9/3/21.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var manager = PostManager()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.fetchPost(for: "all")
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    // cellForRowAt defines what each row at each "address" looks like
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = posts[indexPath.row] // get the post that corresponds to the row
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = "r/\(post.subreddit) ⬆\(post.ups) 🗣\(post.numComments)"
        
        
        return cell
    }
    
}


extension TableViewController: PostManagerDelegate {
    func didFetchData(posts: [Post]) {
        DispatchQueue.main.async {
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    func didFail(error: Error?) {
        print(error as Any)
    }
    
    
}

extension TableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let subreddit = searchBar.text else { return }
        manager.fetchPost(for: subreddit)
        searchBar.text = ""
    }
}
