//
//  RegisterViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    @IBOutlet weak var registrationLabel: UILabel! {
        didSet {
            self.registrationLabel.textColor = UIColor.white
        }
    }
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            self.nameTextField.placeholder = "Name"
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.keyboardType = .emailAddress
            self.emailTextField.placeholder = "Email"
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.isSecureTextEntry = true
            self.passwordTextField.placeholder = "Password"
        }
    }
    @IBOutlet weak var confirmButton: UIButton! {
        didSet {
            self.confirmButton.layer.cornerRadius = 5
            self.confirmButton.layer.borderColor = UIColor.lightGray.cgColor
            self.confirmButton.layer.borderWidth = 2
            self.confirmButton.clipsToBounds = true
            self.confirmButton.backgroundColor = UIColor.white
            self.confirmButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeAlamofire
        self.navigationController?.navigationBar.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func didTapConfirmButton(_ sender: Any) {
        guard let name = self.nameTextField.text, let password = self.passwordTextField.text, let email = self.emailTextField.text else {
            return
        }
        
        let parameters : Parameters = [SignUpParameters.name: name, SignUpParameters.email: email, SignUpParameters.password: password]
        APIUserService.getSharedInstance().signUpUser(parameters: parameters) { (success, errorMessage) in
            if success {
                let alert = UIAlertController(title: "Deu bom", message: "Meus parabens", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if let message = errorMessage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}
