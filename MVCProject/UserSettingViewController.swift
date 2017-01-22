//
//  UserSettingViewController.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 22..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserSettingViewController: UIViewController {

    @IBOutlet var authTokenTextField: UITextField!
    @IBOutlet var userTextField: UITextField!
    @IBOutlet var repoTextField: UITextField!
    @IBOutlet var nextBarButtonItem: UIBarButtonItem!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nextBarButtonItem.rx.tap.subscribe(onNext:{ [unowned self] in
            RepoManager.repo = self.repoTextField.text!
            RepoManager.user = self.userTextField.text!
            if let token: String = self.authTokenTextField.text, token.characters.count != 0 {
                RepoManager.token = token
            }
            self.performSegue(withIdentifier: "IssuesViewControllerPushSegue", sender: nil)
        }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let viewController = segue.destination as? IssuesViewController {
            
        }
    }
 

}
