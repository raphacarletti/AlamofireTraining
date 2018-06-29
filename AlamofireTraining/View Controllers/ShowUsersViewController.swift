//
//  ShowUsersViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import UIKit

class ShowUsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: UITableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UITableViewCell.self))
        }
    }
    
    var users : [UserCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))]
        CoreDataService.getSharedInstance().fetch(entityName: UserCoreData.entityName) { (users) in
            if let users = users as? [UserCoreData] {
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
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
}

extension ShowUsersViewController: UITableViewDelegate {
    
}

extension ShowUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = self.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.id)"
        return cell
    }
}
