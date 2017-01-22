//
//  IssueDetailViewPresenter.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 22..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import RxDataSources
import RxKeyboard

class IssueDetailViewPresenter {
    weak var viewController: IssueDetailViewController!
    let disposeBag = DisposeBag()
    var issue: Issue!
    let commentsVariable: Variable<[Comment]> = Variable([])
    
    init(vc: IssueDetailViewController, issue: Issue) {
        viewController = vc
        self.issue = issue
        
        API.getIssueComments(number: issue.number).bindTo(commentsVariable).addDisposableTo(disposeBag)
        
        rxAction()
    }
    
}

extension IssueDetailViewPresenter {
    func rxAction() {
        commentsVariable.asObservable().bindTo(self.viewController.tableView.rx.items(cellIdentifier: "CommentCell", cellType: CommentCell.self)) { (index: Int, comment: Comment, cell: CommentCell) in
            cell.profileImageView.sd_setImage(with: URL(string: comment.user.avatarUrl)!)
            cell.nicknameLabel.text = comment.user.login
            cell.commentLabel.text = comment.body
            }.addDisposableTo(disposeBag)
        
        RxKeyboard.instance.frame.drive(onNext: { frame in
            print(frame)
        }).addDisposableTo(disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: {[unowned self] keyboardVisibleHeight in
                self.viewController.inputViewBottomSpaceContraint.constant =  keyboardVisibleHeight
                print(keyboardVisibleHeight)
                
                self.viewController.tableView.contentInset.bottom = keyboardVisibleHeight + 60
            })
            .addDisposableTo(disposeBag)
        
        self.viewController.commentPostButton.rx.tap.asObservable().flatMap { [unowned self]  () -> Observable<Comment> in
            guard let commentText = self.viewController.inputTextField.text else {
                return Observable.empty()
            }
            return API.createIssueComment(number: (self.issue?.number)!, body: commentText)
            }.subscribe(onNext: {[unowned self] comment in
                self.viewController.inputTextField.text = nil
                self.viewController.inputTextField.resignFirstResponder()
                print(comment)
                
                let newComments = self.commentsVariable.value + [comment]
                self.commentsVariable.value = newComments
                
                guard let oldIssue = self.issue else {
                    return
                }
                Issues.instance.changeIssue(oldIssue: oldIssue, newIssue: oldIssue.setCommentCount(newCount: newComments.count))
            }).addDisposableTo(disposeBag)
    }
}
