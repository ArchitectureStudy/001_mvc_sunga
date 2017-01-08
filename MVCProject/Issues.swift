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
    let id: Int
    let title: String
    let user: User
    
    init(map: Map) throws {
        id = try map.value("id")
        title = try map.value("title")
        user = try map.value("user")
    }
    
    mutating func mapping(map: Map) {
        id >>> map["id"]
        title >>> map["title"]
        user >>> map["user"]
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

class Issues {
    
    static var instance: Issues = {
        return Issues()
    } ()
    
    private init() {
        
    }
    
    var disposeBag = DisposeBag()
    let issuesSuject: PublishSubject<[Issue]> = PublishSubject<[Issue]>()
    
    func find(user: String, repo: String) {
        
//        issuesSuject.bindTo(<#T##binder: (PublishSubject<[Issue]>) -> R##(PublishSubject<[Issue]>) -> R#>)
        API.repoIssues(user: user, path: repo).bindTo(issuesSuject).addDisposableTo(disposeBag)
//        API.repoIssues(user: user, path: repo).subscribe(onNext: { [unowned self] (issues: [Issue] ) in
//            print(issues)
//            self.issuesSuject.onNext(issues)
//        }).addDisposableTo(disposeBag)
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
