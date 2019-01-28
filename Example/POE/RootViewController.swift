//
//  RootViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 05.04.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import POE

class RootViewController: UIViewController, POEDelegate {

    let introVC = IntroViewController()
    var bridgeVC: UINavigationController?
    let conctVC = ConnectingViewController()
    let errorVC = ErrorViewController()

    var connectionSteps = [DispatchWorkItem]()

    public init() {
        super.init(nibName: "LaunchScreen",
                   bundle: Bundle(for: RootViewController.classForCoder()))

        // You can register yourself here explicitly, or rely on the fact,
        // that you're the presenting view controller, which is also supported.
        // In that case you can simplify that code to a direct initialization
        // without the need to make bridgeVC optional.
        bridgeVC = BridgeSelectViewController.init(
            currentId: UserDefaults.standard.integer(forKey: "use_bridges"),
            noBridgeId: 0,
            providedBridges: [1: "obfs4", 2: "meek-amazon", 3: "meek-azure"],
            customBridgeId: 99,
            customBridges: UserDefaults.standard.stringArray(forKey: "custom_bridges"),
            delegate: self)

        introVC.modalTransitionStyle = .crossDissolve
        conctVC.modalTransitionStyle = .crossDissolve
        errorVC.modalTransitionStyle = .crossDissolve
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.bool(forKey: "did_intro") {
            conctVC.autoClose = true
            present(conctVC, animated: animated, completion: nil)
            connect()
        }
        else {
            present(introVC, animated: animated, completion: nil)
        }
    }

    // MARK: - POEDelegate

    /**
         Callback, after the user finished the intro and selected, if she wants to
         use a bridge or not.

         - parameter useBridge: true, if user selected to use a bridge, false, if not.
     */
    func introFinished(_ useBridge: Bool) {
        UserDefaults.standard.set(true, forKey: "did_intro")

        if useBridge {
            introVC.present(bridgeVC!, animated: true)
            return
        }

        UserDefaults.standard.set(0, forKey: "use_bridge")

        introVC.present(conctVC, animated: true)

        connect()
    }

    /**
         Receive this callback, after the user finished the bridges configuration.

         - parameter bridgesId: the selected ID of the list you gave in the constructor of
         BridgeSelectViewController.
         - parameter customBridges: the list of custom bridges the user configured.
     */
    func bridgeConfigured(_ bridgesId: Int, customBridges: [String]) {
        UserDefaults.standard.set(bridgesId, forKey: "use_bridges")
        UserDefaults.standard.set(customBridges, forKey: "custom_bridges")

        if conctVC.presentingViewController != nil {
            // Already showing - do connection again from beginning.
            connect()
        }
        else {
            // Not showing - present the ConnectingViewController and start connecting afterwards.
            introVC.present(conctVC, animated: true, completion: {
                self.connect()
            })
        }
    }

    /**
     Receive this callback, when the user pressed the gear icon in the ConnectingViewController.

     This probably means, the connection doesn't work and the user wants to configure bridges.

     Cancel the connection here and show the BridgeSelectViewController afterwards.
     */
    func changeSettings() {
        cancel()
        conctVC.present(bridgeVC!, animated: true)
    }

    /**
        Callback, after the user pressed the "Start Browsing" button.
     */
    func userFinishedConnecting() {
        conctVC.present(errorVC, animated: true)
    }

    // MARK: - Private

    private func connect() {
        conctVC.connectingStarted()

        connectionSteps = [
            DispatchWorkItem { self.conctVC.updateProgress(0.25) },
            DispatchWorkItem { self.conctVC.updateProgress(0.5) },
            DispatchWorkItem { self.conctVC.updateProgress(0.75) },
            DispatchWorkItem { self.conctVC.updateProgress(1) },
            DispatchWorkItem { self.conctVC.connectingFinished() },
        ]

        var count = 0.0
        for step in connectionSteps {
            count += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + count, execute: step)
        }
    }

    private func cancel() {
        for step in connectionSteps {
            step.cancel()
        }

        connectionSteps = []
    }
}
