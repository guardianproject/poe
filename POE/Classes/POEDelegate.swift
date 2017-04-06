//
//  POEDelegate.swift
//  Pods
//
//  Created by Benjamin Erhart on 05.04.17.
//
//

import UIKit

@objc public protocol POEDelegate: NSObjectProtocol {

    /**
        Receive this callback, after the user finished the intro and selected, if she wants to
        use a bridge or not.
     
        - parameter useBridge: true, if user selected to use a bridge, false, if not.
     */
    func introFinished(_ useBridge: Bool)

    /**
        Receive this callback, after the user pressed the "Start Browsing" button.
     */
    func connectingFinished()
}
