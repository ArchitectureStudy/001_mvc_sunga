//
//  IssuesViewPresenter.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 22..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 프레젠터는 뷰컨트롤러를 같는다.
// 뷰에서 입력이 들어오면 처리해서 모델에 반영한다.
// 모델이 변경되면 처리해서 뷰에 반영해준다.
class IssuesViewPresenter {
    weak var viewController: IssuesViewController!
    let disposeBag = DisposeBag()
    
    init(vc: IssuesViewController) {
        viewController = vc
        Issues.instance.issuesVariable.asObservable().subscribe(onNext: reloadData).addDisposableTo(disposeBag)
        Issues.instance.find()
    }
    
    func reloadData(issues: [Issue]) {
        self.viewController.datasource = issues
        self.viewController.tableView.reloadData()
    }
    
    func pushDetailView(indexPath: IndexPath) {
        let viewController = Scene.issueDetail.viewController as! IssueDetailViewController
        let issue = Issues.instance.issuesVariable.value[indexPath.row]
        viewController.issue = issue
        self.viewController.navigationController?.pushViewController(viewController, animated: true)
    }
}

