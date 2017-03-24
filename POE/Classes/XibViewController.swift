//
//  XibViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 24.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

/**
    Base class which initializes by default with a XIB/NIB of the same name as the child class.
 
    See
    - [Load assets from bundle resources in Cocoapods](https://the-nerd.be/2015/08/07/load-assets-from-bundle-resources-in-cocoapods/)
    - [Get ClassName without referencing self](http://stackoverflow.com/questions/31735429/get-classname-without-referencing-self)
 */
public class XibViewController: UIViewController {

    public init() {
        super.init(nibName: String(describing: type(of: self)),
                   bundle: Bundle(for: XibViewController.classForCoder()))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
