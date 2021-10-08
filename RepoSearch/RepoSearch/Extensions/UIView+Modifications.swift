//
//  UIView+Modifications.swift
//  RepoSearch
//
//  Created by Nikola Barbarić on 08.10.2021..
//

import UIKit

extension UIView {
    func makeRounded(withCornerRadius radius: Double) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
    func makeRoundedTopCorners(withCornerRadius radius: Double){
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
