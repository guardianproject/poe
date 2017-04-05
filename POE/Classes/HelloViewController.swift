//
//  HelloViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 22.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

class HelloViewController: XibViewController {
    
    @IBOutlet weak var changeLangBt: UIButton!

    @IBAction func changeLang() {
        print("'Change language' button pressed!")
    }
}
