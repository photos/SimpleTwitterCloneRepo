//
//  SwitterTableViewCell.swift
//  Switter
//
//  Created by Forrest Collins on 6/12/15.
//  Copyright (c) 2015 Forrest Collins. All rights reserved.
//

import UIKit

class SwitterTableViewCell: UITableViewCell, UITableViewDelegate, UITextViewDelegate {

    //-------------------
    // MARK: - UI Outlets
    //-------------------
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var switterCellTextView: UITextView!
}
