//
//  Constants.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import UIKit

struct StoryboardNames {
    static let login = "Login"
    static let showText = "ShowText"
    static let tabBar = "TabBar"
}

struct ViewControllerName {
    static let register = "RegisterViewController"
    static let fullText = "FullTextViewController"
}

struct TableCell {
    static let cell = "cell"
}

struct AlamofireConstants {
    static let baseUrl = "https://apiecho.cf/"
    static let signUpUrl = "api/signup/"
    static let signInUrl = "api/login/"
    static let logoutUrl = "api/logout/"
    static let getTextUrl = "api/get/text/"
    static let getPersonUrl = "api/get/person/"
    static let authorization = "Authorization"
    static let jsonResponse = "application/json"
    static let success = "success"
    static let errors = "errors"
    static let message = "message"
    static let data = "data"
}

struct SignUpParameters {
    static let email = "email"
    static let name = "name"
    static let password = "password"
}

struct SignInParameters {
    static let email = "email"
    static let password = "password"
}

struct GetParameters {
    static let locale = "Locale"
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
    static let createdAt = "createdAt"
    static let updatedAt = "updatedAt"
}

struct UserCoreDataAPIKeys {
    static let email = "email"
    static let name = "name"
    static let password = "password"
    static let id = "uid"
    static let role = "role"
    static let status = "status"
    static let accessToken = "access_token"
    static let createdAt = "created_at"
    static let updatedAt = "updated_at"
}

struct TextCoreDataKeys {
    static let text = "text"
}

struct TextCoreDataAPIKeys {
    static let text = "data"
}


struct UserDefaultsKey {
    static let currentUserUid = "CurrentUserUid"
}

struct ImageConstants {
    static let textIcon = UIImage(named: "text_icon")
    static let personIcon = UIImage(named: "person_icon")
}

struct PersonCoreDataKey {
    static let address = "address"
    static let bio = "bio"
    static let city = "city"
    static let country = "country"
    static let email = "email"
    static let firstName = "firstName"
    static let ipAddress = "ipAddress"
    static let lastName = "lastName"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let name = "name"
    static let phoneNumber = "phoneNumber"
    static let timeZone = "timeZone"
    static let title = "title"
}

struct PersonCoreDataAPIKeys {
    static let address = "address"
    static let bio = "bio"
    static let city = "city"
    static let country = "country"
    static let email = "email"
    static let firstName = "first_name"
    static let ipAddress = "ip_address"
    static let lastName = "last_name"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let name = "name"
    static let phoneNumber = "phone_number"
    static let timeZone = "timezone"
    static let title = "title"
}


