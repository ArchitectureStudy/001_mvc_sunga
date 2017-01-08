//
//  IssuesViewController.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 8..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssueCell: UITableViewCell {
    @IBOutlet var idOutlet: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func prepareForReuse() {
        idOutlet.text = ""
        titleLabel.text = ""
    }
}

class IssuesViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet var tableView: UITableView!
    var issuesSubject: PublishSubject<[Issue]>?
    var datasource:[Issue] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        issuesSubject = Issues.instance.issuesSuject
        issuesSubject?.subscribe(onNext: { [unowned self] issues in
            self.datasource = issues
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)
        Issues.instance.find(user: "JakeWharton", repo: "DiskLruCache")
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
        cell.idOutlet.text = "\(issue.id)"
        cell.titleLabel.text =  "\(issue.title)"
        return cell
    }
}
