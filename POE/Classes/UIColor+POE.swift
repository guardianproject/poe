//
//  UIColor+POE.swift
//  POE
//
//  Created by Benjamin Erhart on 09.10.19.
//

import UIKit

public extension UIColor {

    /**
     Background, dark purple, code #3F2B4F
     */
    @objc
    static var poeAccent = UIColor(named: "Accent", in: XibViewController.getBundle(), compatibleWith: nil)

    /**
     Intro progress bar background, darker purple, code #352144
     */
    @objc
    static var poeAccentDark = UIColor(named: "AccentDark", in: XibViewController.getBundle(), compatibleWith: nil)

    /**
     Background for connecting view, light Tor purple, code #A577BB
     */
    @objc
    static var poeAccentLight = UIColor(named: "AccentLight", in: XibViewController.getBundle(), compatibleWith: nil)

    /**
     Red error view background, code #FB5427
     */
    @objc
    static var poeError = UIColor.init(named: "Error", in: XibViewController.getBundle(), compatibleWith: nil)

    /**
     Green connected indicator line, code #7ED321
     */
    @objc
    static var poeOk = UIColor(named: "Ok", in: XibViewController.getBundle(), compatibleWith: nil)
}
