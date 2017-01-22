//
//  Scene.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 22..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit

enum Scene {
    case issues
    case issueDetail
}

extension Scene {
    var viewController: UIViewController {
        get {
            switch self {
            case .issues:
                return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IssuesViewController")
            case .issueDetail:
                return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IssueDetailViewController")
            }
        }
    }
}

