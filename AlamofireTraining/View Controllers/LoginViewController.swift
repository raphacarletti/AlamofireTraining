//
//  LoginViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/29/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var loginLabel: UILabel! {
        didSet {
            self.loginLabel.textColor = UIColor.white
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
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            self.loginButton.layer.cornerRadius = 5
            self.loginButton.layer.borderColor = UIColor.lightGray.cgColor
            self.loginButton.layer.borderWidth = 2
            self.loginButton.clipsToBounds = true
            self.loginButton.backgroundColor = UIColor.white
            self.loginButton.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            self.signUpButton.backgroundColor = UIColor.lightGray
            self.signUpButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.orangeAlamofire
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        guard let password = self.passwordTextField.text, let email = self.emailTextField.text else {
            return
        }
        
        let parameters : Parameters = [SignInParameters.email: email, SignInParameters.password: password]
        APIUserService.getSharedInstance().signInUser(parameters: parameters) { (success, errorMessage, uid) in
            DispatchQueue.main.sync {
                if success, let uid = uid {
                    UserDefaults.standard.set(uid, forKey: UserDefaultsKey.currentUserUid)
                    let alert = UIAlertController(title: "Deu bom", message: "Meus parabens", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        NavigationUtils.goToMain()
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
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.login, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerName.register)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
