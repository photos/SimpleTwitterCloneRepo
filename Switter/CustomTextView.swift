//
//  CustomTextView.swift
//  Switter
//
//  Created by Forrest Collins on 3/13/16.
//  Copyright © 2016 Forrest Collins. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    override func drawRect(rect: CGRect) {
        layer.cornerRadius = 2
        clipsToBounds = true
    }
}
