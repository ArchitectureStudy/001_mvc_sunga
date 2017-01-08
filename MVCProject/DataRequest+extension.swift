//
//  DataRequest+extension.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 8..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension DataRequest {
    fileprivate func responseSwiftyJSON(_ completionHandler: @escaping (DataResponse<JSON>) -> Void) -> Self {
        return responseSwiftyJSON(queue: nil, options:JSONSerialization.ReadingOptions.allowFragments, completionHandler:completionHandler)
    }
    
    public func responseSwiftyJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler:@escaping (DataResponse<JSON>) -> Void)
        -> Self
    {
        
        let responseSerializer = DataResponseSerializer<JSON> { (request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Result<JSON> in
            guard error == nil else { return .failure(error!) }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: options)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                if let _ = response
                {
                    return .success(SwiftyJSON.JSON(value))
                } else {
                    //                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = NSError(domain: "Error", code:1000 , userInfo: nil)
                    return .failure(error)
                }
            case .failure(let error):
                return .failure(error)
            }
            
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: { (response) in
            DispatchQueue.global(qos: .default).async(execute: {
                (queue ?? DispatchQueue.main).async(execute: {
                    completionHandler(response)
                })
            })
        })
    }
    
}
