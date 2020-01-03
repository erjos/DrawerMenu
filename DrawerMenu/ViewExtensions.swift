//
//  ViewExtensions.swift
//  DrawerMenu
//
//  Created by Ethan Joseph on 1/3/20.
//  Copyright © 2020 EJDevelopment. All rights reserved.
//
import Foundation
import UIKit

extension UIView {
    func setWidth(_ width: CGFloat) {
        self.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: width, height: self.frame.height)
    }
    
    func setHeight(_ height: CGFloat) {
        self.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: self.frame.width , height: height)
    }
    
    func setSize(_ width: CGFloat, _ height: CGFloat) {
        self.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: width , height: height)
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 3.0, height: 0.0)
        self.layer.shadowRadius = 3.0
        self.layer.cornerRadius = 0.0
    }
}
