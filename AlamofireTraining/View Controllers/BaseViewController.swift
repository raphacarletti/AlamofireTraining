//
//  BaseViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/29/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

enum ViewControllerStatus {
    case Text
    case Person
}

class BaseViewController: UIViewController {
    var status: ViewControllerStatus? = nil {
        didSet {
            if let status = self.status {
                switch status {
                case .Text:
                    self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: ImageConstants.textIcon, style: .plain, target: self, action: #selector(getText))]
                case .Person:
                    self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: ImageConstants.personIcon, style: .plain, target: self, action: #selector(getPerson))]
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func logout() {
        if let _ = APIUserService.getSharedInstance().currentUser?.accessToken {
            CoreDataService.getSharedInstance().deleteAll { (success) in
                if success {
                    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.currentUserUid)
                    DispatchQueue.main.async {
                        NavigationUtils.goToLogin()
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Nao foi possivel dar logout", preferredStyle: UIAlertControllerStyle.alert)
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
    
    @objc func getPerson() {
        APIUserService.getSharedInstance().getPerson(completion: { (success, errorMessage) in
            if success {
                self.insertNewPerson()
            } else if let message = errorMessage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func insertNewText() {
        
    }
    
    func insertNewPerson() {
        
    }
}
