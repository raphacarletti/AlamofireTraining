//
//  CoreDataParseable.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataParseable {
    associatedtype T
    
    static var entityName : String { get }
    
    static func findIfExists(dict: [String : Any], completion: @escaping (_ object: T?)->())
    static func create(dict: [String : Any], completion: @escaping (_ object: T?)->())
    func merge(dict: [String : Any], completion: @escaping (_ didChange: Bool)->())
}
