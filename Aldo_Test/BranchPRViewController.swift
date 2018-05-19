//
//  BranchPRViewController.swift
//  Aldo_Test
//
//  Created by François Gagnon on 18-05-19.
//  Copyright © 2018 FoG Développement Mobile Inc. All rights reserved.
//

import UIKit

class BranchPRViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var branch: Branch! {
        didSet {
//            self.fetchBranchPR(branch: branch)
        }
    }
    
    var repo: Repo! {
        didSet {
            self.fetchBranchPR(repo: repo)
        }
    }

    
    var prlist: [BranchPR]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pull Requests"
        self.tableView.register(UINib(nibName: "BranchPRTableViewCell", bundle: nil), forCellReuseIdentifier: "BranchPRCell")
    }

    func fetchBranchPR(repo: Repo!) {
        if let repoName = repo.name,
            let owner = repo.ownerLogin {
            BranchPR.getBranchPR(repo: repoName, owner: owner) { (branchPR, error) in
                self.prlist = branchPR
                self.tableView.reloadData()
            }
        }
    }
    
}

extension BranchPRViewController: UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BranchPRCell", for: indexPath) as? BranchPRTableViewCell {
            if let branchPR = self.prlist?[indexPath.row] {
                cell.branchPR = branchPR
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
