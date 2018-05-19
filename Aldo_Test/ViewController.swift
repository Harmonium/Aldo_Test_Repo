//
//  ViewController.swift
//  Aldo_Test
//
//  Created by François Gagnon on 18-05-14.
//  Copyright © 2018 FoG Développement Mobile Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var repos: [Repo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repos"
        self.tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if (!defaults.bool(forKey: "loadingOAuthToken")) {
            self.loadInitialData()
        }
    }
    
    func loadInitialData() {
        if (!GitHubAPIManager.sharedInstance.hasOAuthToken()) {
            GitHubAPIManager.sharedInstance.oauthTokenCompletionHandler = {
                (error) -> Void in
                if let receivedError = error {
                    print(receivedError)
                    // TODO: handle error
                    // TODO: issue: don't get unauthorized if we try this query
                    GitHubAPIManager.sharedInstance.startOAuth2Login()
                } else {
                    self.fetchMyRepos()
                }
            }
            GitHubAPIManager.sharedInstance.startOAuth2Login()
        } else {
            self.fetchMyRepos()
        }
    }

    func fetchMyRepos() {
        Repo.getMyRepos( completionHandler: { (fetchedRepos, error) in
            if let receivedError = error {
                print(receivedError)
                GitHubAPIManager.sharedInstance.OAuthToken = nil
                // TODO: display error
            } else {
                self.repos = fetchedRepos
                for (index, repo) in fetchedRepos.enumerated() {
                    self.getLesImages(repo: repo) {
                        if index == fetchedRepos.count - 1 {
                            self.tableView.reloadData()
                        }
                    }
                }
           }
        })
    }
    
    func getLesImages(repo: Repo, _ completion: @escaping () -> Void) {
            repo.getTest(url: repo.avatarURL!, { (image) in
                repo.avatarImage = image
                completion()
                
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBranchesSegue",
            let repo = sender as? Repo,
            let repoBranchesViewController = segue.destination as? RepoBranchesViewController {
            repoBranchesViewController.repo = repo
        }
    }
}

extension ViewController: UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? RepoTableViewCell {
            if let repoSite = self.repos?[indexPath.row] {
                cell.repo = repoSite
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repo = self.repos?[indexPath.row] {
            self.performSegue(withIdentifier: "ShowBranchesSegue", sender: repo)
        }
    }
}
