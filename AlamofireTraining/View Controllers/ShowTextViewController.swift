//
//  ShowUsersViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import UIKit

class ShowTextViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
            self.tableView.register(UINib(nibName: String(describing: UITableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UITableViewCell.self))
        }
    }
    
    var texts : [TextCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.status = ViewControllerStatus.Text
        self.fetchTexts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchTexts() {
        CoreDataService.getSharedInstance().fetch(entityName: TextCoreData.entityName) { (texts) in
            if let texts = texts as? [TextCoreData] {
                self.texts = texts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func insertNewText() {
        self.fetchTexts()
    }
}

extension ShowTextViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        let text = self.texts[indexPath.row]
        let storyboard = UIStoryboard(name: StoryboardNames.showText, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerName.fullText) as? FullTextViewController {
            vc.text = text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ShowTextViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.cell, for: indexPath)
        let text = self.texts[indexPath.row]
        cell.textLabel?.text = text.text
        return cell
    }
}
