//
//  FullTextViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/29/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit

class FullTextViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var text: TextCoreData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = self.text {
            self.textView.text = text.text
        } else {
            self.textView.text = "Can't load text"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
