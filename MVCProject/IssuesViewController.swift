//
//  IssuesViewController.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 8..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit

class IssuesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var datasource:[Issue] = []
    var viewPresenter: IssuesViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewPresenter = IssuesViewPresenter(vc: self)
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension IssuesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell", for: indexPath) as? IssueCell else {
            return IssueCell()
        }
        let issue = datasource[indexPath.row]
        cell.idOutlet.text = "\(issue.number)"
        cell.titleLabel.text =  "\(issue.title)"
        cell.commentCountLabel.text = "\(issue.commentCount)"
        return cell
    }
}

extension IssuesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewPresenter.pushDetailView(indexPath: indexPath)
    }
}

