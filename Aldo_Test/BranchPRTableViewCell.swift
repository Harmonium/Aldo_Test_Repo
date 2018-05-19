//
//  BranchPRTableViewCell.swift
//  Aldo_Test
//
//  Created by François Gagnon on 18-05-19.
//  Copyright © 2018 FoG Développement Mobile Inc. All rights reserved.
//

import UIKit

protocol BranchPRTableViewCellPresenter {
    func getPRNumber() -> String?
    func getPRName() -> String?
    func getPRMessage() -> String?
    func getStatus() -> String?
}

class BranchPRTableViewCell: UITableViewCell {

    @IBOutlet weak var prNumber: UILabel!
    @IBOutlet weak var prName: UILabel!
    @IBOutlet weak var prMessage: UILabel!
    @IBOutlet weak var prStatus: UILabel!
    
    var branchPR: BranchPRTableViewCellPresenter? {
        didSet {
            if let branchPR = self.branchPR {
                self.prNumber.text = branchPR.getPRNumber()
                self.prName.text = branchPR.getPRName()
                self.prMessage.text = branchPR.getPRMessage()
                self.prStatus.text = branchPR.getStatus()
            } else {
                self.prepareForReuse()
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BranchPR: BranchPRTableViewCellPresenter {
    func getPRNumber() -> String? {
        if let prNumber = self.prNumber {
            return String(prNumber)
        }
        return nil
    }
    
    func getPRName() -> String? {
        if let prName = self.prName {
            return prName
        }
        return nil
    }
    
    func getPRMessage() -> String? {
        if let prMessage = self.prMessage {
            return prMessage
        }
        return nil
    }
    
    func getStatus() -> String? {
        if let prStatus = self.prStatus {
            return prStatus
        }
        return nil
    }
}
