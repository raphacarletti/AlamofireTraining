//
//  APIUserService.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import Alamofire


class APIUserService {
    // MARK: - Variables
    private static var sharedInstance: APIUserService?
    var currentUser: UserCoreData? = nil
    
    // MARK: - Initializations Methods
    private init() {}
    
    static func getSharedInstance() -> APIUserService {
        guard let checkedSharedInstance = self.sharedInstance else {
            let newInstance = APIUserService()
            self.sharedInstance = newInstance
            
            return newInstance
        }
        
        return checkedSharedInstance
    }
    
    func signUpUser(parameters: Parameters, completion: @escaping (_ success: Bool, _ errorMessage: String?)->()) {
        Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.signUpUrl)", method: .post, parameters: parameters).validate(contentType: [AlamofireConstants.jsonResponse]).responseJSON { (response) in
            if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                if success {
                    UserCoreData.findIfExists(dict: json, completion: { (user) in
                        if let user = user {
                            user.merge(dict: json, completion: { (didChange) in
                                self.currentUser = user
                                completion(true, nil)
                            })
                        } else {
                            UserCoreData.create(dict: json, completion: { (user) in
                                if let _ = user {
                                    self.currentUser = user
                                    completion(true, nil)
                                }
                            })
                        }
                    })
                } else if let errors = json[AlamofireConstants.errors] as? [Any], let error = errors.first as? [String: Any], let message = error[AlamofireConstants.message] as? String {
                    completion(false, message)
                }
            }
        }
    }
    
    func signInUser(parameters: Parameters, completion: @escaping (_ success: Bool, _ errorMessage: String?)->()) {
        Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.signInUrl)", method: .post, parameters: parameters).validate(contentType: [AlamofireConstants.jsonResponse]).responseJSON { (response) in
            if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                if success {
                    UserCoreData.findIfExists(dict: json, completion: { (user) in
                        if let user = user {
                            user.merge(dict: json, completion: { (didChange) in
                                self.currentUser = user
                                completion(true, nil)
                            })
                        } else {
                            UserCoreData.create(dict: json, completion: { (user) in
                                if let _ = user {
                                    self.currentUser = user
                                    completion(true, nil)
                                }
                            })
                        }
                    })
                } else if let errors = json[AlamofireConstants.errors] as? [Any], let error = errors.first as? [String: Any], let message = error[AlamofireConstants.message] as? String {
                    completion(false, message)
                }
            }
        }
    }
    
    func logoutUser(accessToken: String, completion: @escaping (_ success: Bool, _ errorMessage: String?)->()) {
        let headers: HTTPHeaders = [AlamofireConstants.authorization: accessToken]
        Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.logoutUrl)", method: .post, headers: headers).validate(contentType: [AlamofireConstants.jsonResponse]).responseJSON { (response) in
            if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                if success {
                    completion(true, nil)
                } else if let errors = json[AlamofireConstants.errors] as? [Any], let error = errors.first as? [String: Any], let message = error[AlamofireConstants.message] as? String {
                    completion(false, message)
                }
            }
        }
    }
}
