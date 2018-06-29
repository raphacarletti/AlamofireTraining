//
//  BaseViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/29/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))]
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: ImageConstants.textIcon, style: .plain, target: self, action: #selector(getText))]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func logout() {
        if let accessToken = APIUserService.getSharedInstance().currentUser?.accessToken {
            APIUserService.getSharedInstance().logoutUser(accessToken: accessToken) { (success, errorMessage) in
                if success {
                    let alert = UIAlertController(title: "Deu bom", message: "VOCE SAIU", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        NavigationUtils.goToLogin()
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else if let message = errorMessage {
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func getText() {
        APIUserService.getSharedInstance().getText(completion: { (success, errorMessage) in
            if success {
                self.insertNewText()
            } else if let message = errorMessage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func insertNewText() {
        
    }
}
