//
//  BridgeViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 05.04.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

class BridgeViewController: XibViewController {
    
    @IBOutlet weak var tellMeMoreBt: UIButton!

    @IBAction func tellMeMore() {
        print("'Tell Me More' button pressed!")
    }
}
