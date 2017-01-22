//
//  RepoManager.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 22..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import Foundation

class RepoManager {
    static var user: String {
        get {
            let userValue = UserDefaults.standard.value(forKey: "user") as! String
            return userValue
        }
        set(user) {
            UserDefaults.standard.set(user, forKey: "user")
        }
    }
    
    static var repo: String {
        get {
            let repoValue = UserDefaults.standard.value(forKey: "repo") as! String
            return repoValue
        }
        set(repo) {
             UserDefaults.standard.set(repo, forKey: "repo")
        }
    }
    
    static var token: String {
        get {
            let tokenValue = UserDefaults.standard.value(forKey: "token") as! String
            return tokenValue
        }
        set(token_) {
            UserDefaults.standard.set(token_, forKey: "token")
        }
    }
}
