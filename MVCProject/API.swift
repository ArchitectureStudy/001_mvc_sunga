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
}

extension ApiBuilder {
    static let BaseURL = "https://api.github.com"
    static let requestManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    var path: String {
        switch self {
        case let .getIssues(user, repo):
            return "/repos/\(user)/\(repo)/issues"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getIssues:
            return .get
        }
    }
    
    var url: String {
        return "\(ApiBuilder.BaseURL)\(self.path)"
    }
    
    func buildRequest(_ parameters: [String: Any]? = nil) -> Observable<JSON> {
        return Observable.create { observer in
            let request = ApiBuilder.requestManager.request(self.url, method: self.method, parameters: parameters).responseSwiftyJSON(completionHandler: { response in
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
    static func repoIssues(user: String, path: String) -> Observable<[Issue]> {
        return ApiBuilder.getIssues(user: user, repo: path).buildRequest().map { json -> [Issue] in
            let jsonString: String = json.rawString()!
            do {
                let issues = try Mapper<Issue>().mapArray(JSONString: jsonString)
                return issues
            } catch {
                return []
            }
        }
    }
}

