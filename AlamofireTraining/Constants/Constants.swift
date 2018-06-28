//
//  Constants.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation

struct AlamofireConstants {
    static let baseUrl = "https://apiecho.cf/"
    static let signUpUrl = "api/signup/"
    static let success = "success"
    static let errors = "errors"
    static let message = "message"
}

struct SignUpParameters {
    static let email = "email"
    static let name = "name"
    static let password = "password"
}

enum UserStatus: Int {
    case active = 10
    case pending = 1
    case deleted = 2
}

enum UserRole: Int {
    case user = 1
    case admin = 10
    case manager = 2
}

struct UserCoreDataKey {
    static let email = "email"
    static let name = "name"
    static let password = "password"
    static let id = "id"
    static let role = "role"
    static let status = "status"
    static let accessToken = "accessToken"
}
