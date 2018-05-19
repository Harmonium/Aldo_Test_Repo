//
//  RepoBranchesViewController.swift
//  Aldo_Test
//
//  Created by François Gagnon on 18-05-17.
//  Copyright © 2018 FoG Développement Mobile Inc. All rights reserved.
//

import UIKit

class RepoBranchesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var repo: Repo! {
        didSet {
            self.fetchRepoBranches(repo: repo)
        }
    }
    
    var brancheslist: [Branch]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Branches"
        self.tableView.register(UINib(nibName: "RepoBranchesTableViewCell", bundle: nil), forCellReuseIdentifier: "BranchCell")
    }
    
    func fetchRepoBranches(repo: Repo) {
        Branch.getRepoBranches(repo: repo.name!, owner: repo.ownerLogin!) { (repoBranches, error) in
            self.brancheslist = repoBranches
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBranchPRSegue",
            let branch = sender as? Branch,
            let branchPRViewController = segue.destination as? BranchPRViewController {
            branchPRViewController.branch = branch
            branchPRViewController.repo = self.repo
        }
    }

}

extension RepoBranchesViewController: UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brancheslist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath) as? RepoBranchesTableViewCell {
            if let repoBranch = self.brancheslist?[indexPath.row] {
                cell.repoBranch = repoBranch
            }
            return cell
        }
        return UITableViewCell()
    }

}

extension RepoBranchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let branch = self.brancheslist?[indexPath.row] {
            self.performSegue(withIdentifier: "ShowBranchPRSegue", sender: branch)
        }
    }
}

