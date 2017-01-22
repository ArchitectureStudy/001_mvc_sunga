//
//  API.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 8..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON
import ObjectMapper

enum ApiBuilder {
    case getIssues(user: String, repo: String)
    case createIssue(user: String, repo: String)
    case createIssueComment(user: String, repo: String, number: Int)
    case getIssueComment(user: String, repo: String, number: Int)
}
//POST /repos/:owner/:repo/issues/:number/comments
extension ApiBuilder {
    static let BaseURL = "https://api.github.com"
    static let requestManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.urlCache = nil
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    fileprivate var path: String {
        switch self {
        case let .getIssues(user, repo):
            return "/repos/\(user)/\(repo)/issues"
        case let .createIssue(user, repo):
            return "/repos/\(user)/\(repo)/issues"
        case let .createIssueComment(user, repo, number):
            return "/repos/\(user)/\(repo)/issues/\(number)/comments"
        case let .getIssueComment(user, repo, number):
            return "/repos/\(user)/\(repo)/issues/\(number)/comments"
        }
    }
//    let endpoint = "https://api.github.com/repos/\(user)/\(repo)/issues/\(number)"
//    let endpoint = "https://api.github.com/repos/\(user)/\(repo)/issues/\(number)/comments"
    
    fileprivate var method: Alamofire.HTTPMethod {
        switch self {
        case .getIssues,
             .getIssueComment :
            return .get
        case .createIssue
            , .createIssueComment:
            return .post
        }
    }
    
    fileprivate var url: String {
        return "\(ApiBuilder.BaseURL)\(self.path)"
    }
    
    fileprivate func DefaultHeaders() -> [String: String] {
        switch self.method {
        case .post:
            return ["Authorization": "token \(RepoManager.token)"]
        default:
            return [:]
        }
    }
    
    func buildRequest(_ parameters: [String: Any]? = nil) -> Observable<JSON> {
        
        
        return Observable.create { observer in
            
            let request = ApiBuilder.requestManager.request(self.url, method: self.method, parameters: parameters,encoding: JSONEncoding.default, headers: self.DefaultHeaders()).responseSwiftyJSON(completionHandler: { response in
                switch (response.result, response.response?.statusCode) {
                case let (.success(json), statusCode) where statusCode! >= 200 && statusCode! < 300:
                    observer.onNext(json )
                    observer.onCompleted()
                case let (.success(_), statusCode):
                    observer.onError(NSError(domain: "Error", code: statusCode ?? 500, userInfo: ["":""]))
                case let (.failure(error) , _ ):
                    observer.onError( error)
                }
            })
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

struct API {
    
    static func repoIssues() -> Observable<[Issue]> {
        return ApiBuilder.getIssues(user: RepoManager.user, repo: RepoManager.repo).buildRequest().map { json -> [Issue] in
            let jsonString: String = json.rawString()!
            do {
                let issues = try Mapper<Issue>().mapArray(JSONString: jsonString)
                return issues
            } catch {
                return []
            }
        }
    }

    static func createIssueComment(number: Int, body: String) -> Observable<Comment> {
        let parameters = ["body": body]        
        return ApiBuilder.createIssueComment(user: RepoManager.user, repo: RepoManager.repo, number: number).buildRequest(parameters).flatMap{ json -> Observable<Comment> in
            let jsonString: String = json.rawString()!
            do {
                let comment = try Mapper<Comment>().map(JSONString: jsonString)
                return Observable.just(comment)
            } catch {
                return Observable.error(NSError(domain: "Error", code: 10011, userInfo: ["":""]))
            }
        }
    }
    
    static func getIssueComments(number: Int) -> Observable<[Comment]> {
        return ApiBuilder.getIssueComment(user: RepoManager.user, repo: RepoManager.repo, number: number).buildRequest().map{ json -> [Comment] in
            let jsonString: String = json.rawString()!
            do {
                let comments = try Mapper<Comment>().mapArray(JSONString: jsonString)
                return comments
            } catch {
                return []
            }
        }
    }
}

