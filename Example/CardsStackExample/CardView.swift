//
//  CardView.swift
//  DynamicStackOfCards
//
//  Created by Pritesh Nandgaonkar on 9/16/16.
//  Copyright © 2016 pritesh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UICollectionViewCell {
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius = 4
        layer.rasterizationScale = UIScreen.main.scale
    }
}
