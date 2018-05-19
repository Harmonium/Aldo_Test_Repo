//
//  Repo.swift
//  Aldo_Test
//
//  Created by François Gagnon on 18-05-15.
//  Copyright © 2018 FoG Développement Mobile Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BranchPR {
    var prNumber: Int?
    var prName: String?
    var prMessage: String?
    var prStatus: String?
    
    init(json: JSON) {
        self.prNumber = json["number"].int
        self.prName = json["title"].string
        self.prMessage = json["labels"]["description"].string
        self.prStatus = json["state"].string
    }

    class func getBranchPR(repo: String, owner: String, completionHandler: @escaping ([BranchPR]?, Error?) -> Void) {
        let path = "https://api.github.com/repos/\(owner)/\(repo)/pulls"
        
        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("PR: \(json)")
                        
                        var branchPRs = [BranchPR]()
                        for (key, branchJson) in json {
                            print(branchJson)
                            let branchPR = BranchPR(json: branchJson)
                            
                            //                            let branchDetail = self.getBranch(repo: repo, owner: owner, branch: branch)
                            //                            branch.messageSHA =
                            branchPRs.append(branchPR)
                        }
                        completionHandler(branchPRs, nil)
                    }
                    
                case .failure(let error):
                    //                    AlertUtilities.presentAlert("Login", message: error.localizedDescription)
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    
                    // TODO: parse out errors more specifically
                    completionHandler(nil, error)
                }
        }

    }
}

class Branch {
    var name: String?
    var sha: String?
    var messageSHA: String?
    
    init(json: JSON) {
        self.name = json["name"].string
        self.sha = json["commit"]["sha"].string
        self.messageSHA = json["commit"]["message"].string
    }
    
    class func getRepoBranches(repo: String, owner: String, completionHandler: @escaping ([Branch]?, Error?) -> Void) {
        let path = "https://api.github.com/repos/\(owner)/\(repo)/branches"

        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Branches: \(json)")
                        
                        var branches = [Branch]()
                        for (key, branchJson) in json {
                            print(branchJson)
                            let branch = Branch(json: branchJson)
                            
//                            let branchDetail = self.getBranch(repo: repo, owner: owner, branch: branch)
//                            branch.messageSHA =
                            branches.append(branch)
                        }
                        completionHandler(branches, nil)
                    }
                    
                case .failure(let error):
                    //                    AlertUtilities.presentAlert("Login", message: error.localizedDescription)
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    
                    // TODO: parse out errors more specifically
                    completionHandler(nil, error)
                }
        }
    }
    
//    func getBranch(repo: String, owner: String, branch: Branch) -> Branch {
//        self.getBranchDetail(repo: repo, owner: owner, branch: branch.name!) { (branchDetail, error) in
//            let messageSHA = branchDetail
//        }
//        return messageSHA
//    }

    func getBranchDetail(repo: String, owner: String, branch: String, completionHandler: @escaping (Branch?, Error?) -> Void) {
        let path = "https://api.github.com/repos/\(owner)/\(repo)/branches/\(branch)"
        
        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Branch: \(json)")
                        
                        let branch = Branch(json: json)
                        print(branch)
                        completionHandler(branch, nil)
                    }
                    
                case .failure(let error):
                    //                    AlertUtilities.presentAlert("Login", message: error.localizedDescription)
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    
                    // TODO: parse out errors more specifically
                    completionHandler(nil, error)
                }
        }
    }

}

class Repo {
    var id: Int?
    var name: String?
    var description: String?
    var ownerLogin: String?
    var url: String?
    var avatarURL: String?
    var type: String?
    var avatarImage: UIImage?
    
//    required init?(response: HTTPURLResponse, representation: AnyObject) {
//        self.name = representation.value(forKey: "name") as? String
//    }

    init(id: Int, name: String, description: String, ownerLogin: String, url: String, avatarURL: String, type: String, avatarImage: UIImage) {
        self.id = id
        self.name = name
        self.description = description
        self.ownerLogin = ownerLogin
        self.url = url
        self.avatarURL = avatarURL
        self.type = type
        self.avatarImage = avatarImage
    }
    
    required init(json: JSON) {
        
        self.avatarURL = json["owner"]["avatar_url"].string
        self.description = json["description"].string
        self.id = json["id"].int
        self.name = json["name"].string
        self.ownerLogin = json["owner"]["login"].string
        self.url = json["url"].string
        let forkType = json["fork"].bool ?? false
        let privateType = json["private"].bool ?? false
        self.type = forkType ? "Fork" : privateType ? "Private" : "Public"
    }

    class func getAvatarOne(url: String, _ completion: @escaping (UIImage?) -> Void) {
        self.getAvatarImage(url: url,
                            success: { (image) in
                                completion(image)
        },
                            failure: {
                                completion(nil)
        })
    }
    
    class func getAvatarImages(repoList: [Repo], completionHandler: @escaping ([Repo]?) -> Void) {
        for repo in repoList {
            let avatarURL = repo.avatarURL
            self.getAvatarOne(url: avatarURL!) { (image) in
                repo.avatarImage = image
            }
        }
        completionHandler(repoList)

    }
    
//    func parseRepo (json: JSON) -> Repo {
//        self.avatarURL = json["owner"]["avatar_url"].string
//        if let avatarURL = self.avatarURL {
//                self.description = json["description"].string
//                self.id = json["id"].string
//                self.name = json["name"].string
//                self.ownerLogin = json["owner"]["login"].string
//                self.url = json["url"].string
//                let forkType = json["fork"].bool ?? false
//                let privateType = json["private"].bool ?? false
//                self.type = forkType ? "Fork" : privateType ? "Private" : "Public"
//                self.avatarURL = json["owner"]["avatar_url"].string
//                return Repo(id: <#T##String#>, name: <#T##String#>, description: <#T##String#>, ownerLogin: <#T##String#>, url: <#T##String#>, avatarURL: <#T##String#>, type: <#T##String#>, avatarImage: <#T##UIImage#>)
//        }
//    }

    class func getMyRepos(completionHandler: @escaping ([Repo], Error?) -> Void) {
        let path = "https://api.github.com/user/repos"
        
        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Repos: \(json)")
                        
                        var repos = [Repo]()
                        for (key, jsonRepo) in json {
                            print(key)
                            print(jsonRepo)
                            let repo = Repo(json: jsonRepo)
                            
                            repos.append(repo)
                        }
                        completionHandler(repos, nil)
                    }
                    
                case .failure(let error):
                    //                    AlertUtilities.presentAlert("Login", message: error.localizedDescription)
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    
                    // TODO: parse out errors more specifically
                    completionHandler([Repo](), error)
                }
        }
    }
    
    func getImageAvatar(url: String, _ completion: @escaping (UIImage) -> Void) {
        self.getTest(url: url, { (image) in
            completion(image)
        })
    }

    

    class func getAvatarImage(url: String, success: @escaping (UIImage?) -> Void, failure: @escaping () -> Void) {
        GitHubAPIManager.sharedInstance.alamofireManager().request(url)
            .validate()
            .responseData { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        if let avatarDecoded = UIImage(data: value) {
                            success(avatarDecoded)
                        }
                    }
                    
                case .failure(let error):
                    //                    AlertUtilities.presentAlert("Login", message: error.localizedDescription)
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    failure()
                }
        }
    }
    
    func getTest(url: String, _ completion: @escaping (UIImage) -> Void) {
        Repo.getAvatarImage(url: url, success: { (image) in
            completion(image!)
        }) {
            
        }
        
    }
}

//extension Repo {
//
//    var avatar: UIImage? {
//        var avatarImage: UIImage?
//        if let avatarURL = self.avatarURL {
//            self.getAvatarImage(url: avatarURL,
//                                success: { (image) in
//                                    avatarImage = image
//            },
//                                failure: {
//                                    avatarImage = nil
//            })
//        }
//        return avatarImage
//    }
//
//}
