//
//  CustomTableView.swift
//  Switter
//
//  Created by Forrest Collins on 3/12/16.
//  Copyright © 2016 Forrest Collins. All rights reserved.
//

import UIKit

class CustomTableView: UITableView {
    
    //-----------------------
    // MARK: - Awake From Nib
    //-----------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorColor = UIColor.clearColor()
        backgroundView = UIImageView(image: UIImage(named: "blurry.jpg"))
    }
}
