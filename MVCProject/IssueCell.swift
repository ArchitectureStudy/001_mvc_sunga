//
//  IssueCell.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 22..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssueCell: UITableViewCell {
    @IBOutlet var idOutlet: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var commentCountLabel: UILabel!
    
    override func prepareForReuse() {
        idOutlet.text = ""
        titleLabel.text = ""
    }
}
