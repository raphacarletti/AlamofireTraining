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
    
    func signUpUser(parameters: Parameters, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ uid: Int16?)->()) {
        Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.signUpUrl)", method: .post, parameters: parameters).validate(contentType: [AlamofireConstants.jsonResponse]).responseJSON { (response) in
            if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                if success {
                    UserCoreData.findIfExists(dict: json, completion: { (user) in
                        if let user = user {
                            user.merge(dict: json, completion: { (didChange) in
                                self.currentUser = user
                                completion(true, nil, user.id)
                            })
                        } else {
                            UserCoreData.create(dict: json, completion: { (user) in
                                if let user = user {
                                    self.currentUser = user
                                    completion(true, nil, user.id)
                                }
                            })
                        }
                    })
                } else if let errors = json[AlamofireConstants.errors] as? [Any], let error = errors.first as? [String: Any], let message = error[AlamofireConstants.message] as? String {
                    completion(false, message, nil)
                }
            }
        }
    }
    
    func signInUser(parameters: Parameters, completion: @escaping (_ success: Bool, _ errorMessage: String?, _ uid: Int16?)->()) {
        Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.signInUrl)", method: .post, parameters: parameters).validate(contentType: [AlamofireConstants.jsonResponse]).responseJSON { (response) in
            if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                if success {
                    UserCoreData.findIfExists(dict: json, completion: { (user) in
                        if let user = user {
                            user.merge(dict: json, completion: { (didChange) in
                                self.currentUser = user
                                completion(true, nil, user.id)
                            })
                        } else {
                            UserCoreData.create(dict: json, completion: { (user) in
                                if let user = user {
                                    self.currentUser = user
                                    completion(true, nil, user.id)
                                }
                            })
                        }
                    })
                } else if let errors = json[AlamofireConstants.errors] as? [Any], let error = errors.first as? [String: Any], let message = error[AlamofireConstants.message] as? String {
                    completion(false, message, nil)
                }
            }
        }
    }
    
    func logoutUser(accessToken: String, completion: @escaping (_ success: Bool, _ errorMessage: String?)->()) {
        let headers: HTTPHeaders = [AlamofireConstants.authorization: "Bearer \(accessToken)"]
        Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.logoutUrl)", method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                if success {
                    completion(true, nil)
                } else if let errors = json[AlamofireConstants.errors] as? [Any], let error = errors.first as? [String: Any], let message = error[AlamofireConstants.message] as? String {
                    completion(false, message)
                }
            }
        }
    }
    
    func getText(completion: @escaping (_ success: Bool, _ errorMessage: String?)->()) {
        if let accessToken = self.currentUser?.accessToken {
            let headers: HTTPHeaders = [AlamofireConstants.authorization: "Bearer \(accessToken)"]
            let parameters: Parameters = [GetParameters.locale: "en_US"]
            Alamofire.request("\(AlamofireConstants.baseUrl)\(AlamofireConstants.getTextUrl)", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if let json = response.result.value as? [String: Any], let success = json[AlamofireConstants.success] as? Bool {
                    if success {
                        TextCoreData.findIfExists(dict: json, completion: { (text) in
                            if let text = text {
                                text.merge(dict: json, completion: { (didChange) in
                                    completion(true, nil)
                                })
                            } else {
                                TextCoreData.create(dict: json, completion: { (text) in
                                    if let text = text {
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
    }
    
    func getCurrentUser(uid: Int16, completion: @escaping (_ success: Bool)->()) {
        let predicate = NSPredicate(format: "id == %i", uid)
        CoreDataService.getSharedInstance().fetch(entityName: UserCoreData.entityName, predicate: predicate) { (users) in
            if let user = users.first as? UserCoreData {
                self.currentUser = user
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
