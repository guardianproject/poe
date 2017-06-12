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
     
        - parameter useBridge: true, if user selected to use a bridge, false, if not. You should 
          show the BridgeSelectViewController then.
     */
    func introFinished(_ useBridge: Bool)

    /**
        Receive this callback, after the user finished the bridges configuration in the BridgeSelectViewController.
 
        - parameter bridgesId: the selected ID of the list you gave in the constructor of 
          BridgeSelectViewController.
        - parameter customBridges: the list of custom bridges the user configured.
     */
    func bridgeConfigured(_ bridgesId: Int, customBridges: [String])

    /**
        Receive this callback, when the user pressed the gear icon in the ConnectingViewController.
     
        This probably means, the connection doesn't work and the user wants to configure bridges.
     
        Cancel the connection here and show the BridgeSelectViewController afterwards.
    */
    func changeSettings()

    /**
        Receive this callback, after the user pressed the "Start Browsing" button.
     */
    func userFinishedConnecting()

    /**
        Receive this callback, when the user changed the locale.
     */
    func localeUpdated(_ localeId: String)
}
