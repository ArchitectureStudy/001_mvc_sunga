//
//  IssueDetailViewController.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 17..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit
import SDWebImage

class IssueDetailViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var issueTextLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var inputViewBottomSpaceContraint: NSLayoutConstraint!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var commentPostButton: UIButton!
    
    var issue: Issue!
    var viewPresenter: IssueDetailViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewPresenter = IssueDetailViewPresenter(vc: self, issue: issue)
        
        nameLabel.text = issue?.user.login
        issueTextLabel.text = issue?.title
        profileImageView.sd_setImage(with: URL(string: (issue?.user.avatarUrl)!))

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

