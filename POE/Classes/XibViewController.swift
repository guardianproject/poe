//
//  XibViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 24.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit
import Localize

/**
    Base class which initializes by default with a XIB/NIB of the same name as the child class.
 
    See
    - [Load assets from bundle resources in Cocoapods](https://the-nerd.be/2015/08/07/load-assets-from-bundle-resources-in-cocoapods/)
    - [Get ClassName without referencing self](http://stackoverflow.com/questions/31735429/get-classname-without-referencing-self)
 */
public class XibViewController: UIViewController {

    private static var bundles: [Bundle] = []

    public init() {
        let bundles = XibViewController.getBundles()

        Localize.update(bundle: bundles[1])
        Localize.update(fileName: "Localizable")

        super.init(nibName: String(describing: type(of: self)), bundle: bundles[0])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Replace standard font with our corporate design font: Roboto
        robotoIt()
    }

    public static func getBundles() -> [Bundle] {
        if bundles.count < 1 {
            let bundle = Bundle(for: XibViewController.classForCoder())

            // CocoaPods manages to move all resources into a bundle inside the framework's bundle,
            // which we pick here.
            let subBundle = Bundle(url: (bundle.url(forResource: "POE", withExtension: "bundle"))!)

            bundles = [bundle, subBundle!]
        }

        return bundles
    }
}
