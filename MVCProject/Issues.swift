//
//  Issues.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 8..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import ObjectMapper

struct Issue: ImmutableMappable {
    let number: Int
    let title: String
    let user: User
    let commentCount: Int
    
    init(map: Map) throws {
        number = try map.value("number")
        title = try map.value("title")
        user = try map.value("user")
        commentCount = try map.value("comments")
    }
    init(number number_: Int, title title_: String, user user_: User, commentCount commentCount_: Int) {
        number = number_
        title = title_
        user = user_
        commentCount = commentCount_
    }
    
    mutating func mapping(map: Map) {
        number >>> map["number"]
        title >>> map["title"]
        user >>> map["user"]
        commentCount >>> map["comments"]
    }
    
    func save(newIssue: Issue) {
        Issues.instance.issuesSaveSubject.onNext((self, newIssue))
    }
    
    func setCommentCount(newCount: Int) -> Issue {
        return Issue(number: number, title: title, user: user, commentCount: newCount)
    }
    
}

struct User: ImmutableMappable {
    let id: Int
    let login: String
    let avatarUrl: String
    
    init(map: Map) throws {
        id = try map.value("id")
        login = try map.value("login")
        avatarUrl = try map.value("avatar_url")
    }
    
    mutating func mapping(map: Map) {
        id >>> map["id"]
        login >>> map["login"]
        avatarUrl >>> map["avatar_url"]
    }
}

struct Comment: ImmutableMappable {
    let id: Int
    let user: User
    let body: String
    
    init(map: Map) throws {
        id = try map.value("id")
        body = try map.value("body")
        user = try map.value("user")
    }
    
    mutating func mapping(map: Map) {
        id >>> map["id"]
        body >>> map["body"]
        user >>> map["user"]
    }
}

class Issues {
    
    static var instance: Issues = {
        return Issues()
    } ()
    
    private init() {
        issuesSaveSubject.subscribe(onNext: changeIssue).addDisposableTo(disposeBag)
    }
    
    var disposeBag = DisposeBag()
    let issuesVariable: Variable<[Issue]> = Variable<[Issue]>([])
    let issuesSaveSubject: PublishSubject<(Issue, Issue)> = PublishSubject<(Issue, Issue)>()
    
    func find() {
        API.repoIssues().bindTo(issuesVariable).addDisposableTo(disposeBag)
    }
    
    func findBy(ordered: Bool) {
        API.repoIssues().bindTo(issuesVariable).addDisposableTo(disposeBag)
    }
    
    func findBy(number: Int) -> Issue? {
        let issues = self.issuesVariable.value
        for issue in issues {
            if issue.number == number {
                return issue
            }
        }
        return nil
    }
    
    func changeIssue(oldIssue: Issue, newIssue: Issue) {
        let issues = self.issuesVariable.value
        let newIssues = issues.map { issue -> Issue in
            if issue.number == oldIssue.number {
                return newIssue
            }
            return issue
        }
        self.issuesVariable.value = newIssues
    }
}


/**
 {
 "url": "https://api.github.com/repos/JakeWharton/DiskLruCache/issues/93",
 "repository_url": "https://api.github.com/repos/JakeWharton/DiskLruCache",
 "labels_url": "https://api.github.com/repos/JakeWharton/DiskLruCache/issues/93/labels{/name}",
 "comments_url": "https://api.github.com/repos/JakeWharton/DiskLruCache/issues/93/comments",
 "events_url": "https://api.github.com/repos/JakeWharton/DiskLruCache/issues/93/events",
 "html_url": "https://github.com/JakeWharton/DiskLruCache/issues/93",
 "id": 198650533,
 "number": 93,
 "title": "what can cause cache is closed",
 "user": {
 "login": "iloveaman",
 "id": 2972036,
 "avatar_url": "https://avatars.githubusercontent.com/u/2972036?v=3",
 "gravatar_id": "",
 "url": "https://api.github.com/users/iloveaman",
 "html_url": "https://github.com/iloveaman",
 "followers_url": "https://api.github.com/users/iloveaman/followers",
 "following_url": "https://api.github.com/users/iloveaman/following{/other_user}",
 "gists_url": "https://api.github.com/users/iloveaman/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/iloveaman/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/iloveaman/subscriptions",
 "organizations_url": "https://api.github.com/users/iloveaman/orgs",
 "repos_url": "https://api.github.com/users/iloveaman/repos",
 "events_url": "https://api.github.com/users/iloveaman/events{/privacy}",
 "received_events_url": "https://api.github.com/users/iloveaman/received_events",
 "type": "User",
 "site_admin": false
 },
 "labels": [
 
 ],
 "state": "open",
 "locked": false,
 "assignee": null,
 "assignees": [
 
 ],
 "milestone": null,
 "comments": 0,
 "created_at": "2017-01-04T08:10:04Z",
 "updated_at": "2017-01-04T08:10:04Z",
 "closed_at": null,
 "body": "what can cause cache is closed?"
 }
 **/
