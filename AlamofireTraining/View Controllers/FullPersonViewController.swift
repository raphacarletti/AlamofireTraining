//
//  FullPersonViewController.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 7/2/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import UIKit
import MapKit

class FullPersonViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var person: PersonCoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setUpView() {
        if let person = self.person {
            self.nameLabel.text = "Name: \(person.name)"
            self.emailLabel.text = "Email: \(person.email)"
            self.bioLabel.text = "Bio: \(person.bio)"
            self.cityCountryLabel.text = "City, Country: \(person.city), \(person.country)"
            self.phoneNumberLabel.text = "Phone Number: \(person.phoneNumber)"
            self.titleLabel.text = "Title: \(person.title)"
            let coordinate = CLLocationCoordinate2DMake(person.latitude, person.longitude)
            let point = MKPointAnnotation()
            point.coordinate = coordinate
            point.title = "Person position"
            self.mapView.addAnnotation(point)
            self.mapView.centerCoordinate = coordinate
            self.mapView.camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: CLLocationDistance.init(5000000), pitch: 0, heading: 0)
        }
    }

}
