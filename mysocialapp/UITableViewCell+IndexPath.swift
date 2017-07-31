//
//  UITableViewCell+IndexPath.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez on 7/15/17.
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
extension UITableViewCell {
    
    var indexPath: IndexPath? {
        return (superview as? UITableView)?.indexPath(for: self)
    }
}
