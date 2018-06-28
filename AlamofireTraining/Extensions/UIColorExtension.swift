//
//  UIColorExtension.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public class var orangeAlamofire : UIColor {
        return UIColor(hex: "ffba7a", alpha: 1)
    }
    
    public class var blueAlamofire : UIColor {
        return UIColor(hex: "9ef2ff", alpha: 1)
    }
    
    public class var lightGray : UIColor {
        return UIColor(hex: "9b9b9b", alpha: 1)
    }
}


extension UIColor {
    
    //MARK: - Convert HEX to RGB
    convenience init(hex: String, alpha: CGFloat) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
}
