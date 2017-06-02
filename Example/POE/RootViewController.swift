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
    let bridgeVC = BridgeSelectViewController(
        currentId: 0,
        noBridgeId: 0,
        providedBridges: [1: "obfs4", 2: "meek-amazon", 3: "meek-azure"],
        customBridgeId: 99)
    let conctVC = ConnectingViewController()
    let errorVC = ErrorViewController()

    public init() {
        super.init(nibName: "LaunchScreen",
                   bundle: Bundle(for: RootViewController.classForCoder()))

        introVC.modalTransitionStyle = .crossDissolve
        conctVC.modalTransitionStyle = .crossDissolve
        errorVC.modalTransitionStyle = .crossDissolve

        let currentId = Locale.current.identifier

        if let localeId = UserDefaults.standard.object(forKey: "locale") as? String {
            if currentId != localeId {
                print("Change locale in your app from '\(currentId)' to '\(localeId)'!")
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.bool(forKey: "did_intro") {
            conctVC.autoClose = true
            present(conctVC, animated: animated, completion: nil)
            connect(UserDefaults.standard.bool(forKey: "use_bridge"))
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
        if useBridge {
            introVC.present(bridgeVC, animated: true)
            return
        }

        UserDefaults.standard.set(true, forKey: "did_intro")
        UserDefaults.standard.set(useBridge, forKey: "use_bridge")

        introVC.present(conctVC, animated: true)

        connect(useBridge)
    }

    /**
        Callback, after the user pressed the "Start Browsing" button.
     */
    func userFinishedConnecting() {
        errorVC.updateProgress(1)
        conctVC.present(errorVC, animated: true)
    }

    /**
        Callback, when the user changed the locale.
     */
    func localeUpdated(_ localeId: String) {
        UserDefaults.standard.set(localeId, forKey:"locale")
    }

    // MARK: - Private

    private func connect(_ useBridge: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.conctVC.connectingStarted()
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.conctVC.updateProgress(0.25)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.conctVC.updateProgress(0.5)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.conctVC.updateProgress(0.75)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.conctVC.updateProgress(1)
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
            self.conctVC.connectingFinished()
        })
    }
}
