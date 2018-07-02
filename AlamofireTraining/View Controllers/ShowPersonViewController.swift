//
//  ShowPersonViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 7/2/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

var number: Double = 0

class ShowPersonViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: UITableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UITableViewCell.self))
        }
    }
    
    var people: [PersonCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.status = ViewControllerStatus.Person
        self.fetchPeople()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchPeople() {
        CoreDataService.getSharedInstance().fetch(entityName: PersonCoreData.entityName) { (people) in
            if let people = people as? [PersonCoreData] {
                self.people = people
                self.tableView.reloadData()
            }
        }
    }
    
    override func insertNewPerson() {
        self.fetchPeople()
    }
}

extension ShowPersonViewController: UITableViewDelegate {
    
}

extension ShowPersonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.cell, for: indexPath)
        let person = self.people[indexPath.row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.phoneNumber
        return cell
    }
}
