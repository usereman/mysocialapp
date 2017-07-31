//
//  CircleView.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez 
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
