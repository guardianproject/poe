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
    let conctVC = ConnectingViewController()
    let errorVC = ErrorViewController()

    var nextVC: UIViewController?

    public init() {
        super.init(nibName: "LaunchScreen",
                   bundle: Bundle(for: RootViewController.classForCoder()))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        present(nextVC ?? introVC, animated: animated, completion: nil)

        if nextVC == conctVC {
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

    // MARK: - POEDelegate

    /**
         Callback, after the user finished the intro and selected, if she wants to
         use a bridge or not.

         - parameter useBridge: true, if user selected to use a bridge, false, if not.
     */
    func introFinished(_ useBridge: Bool) {
        nextVC = conctVC

        dismiss(animated: true, completion: nil)
    }

    /**
        Callback, after the user pressed the "Start Browsing" button.
     */
    func userFinishedConnecting() {
        nextVC = errorVC

        dismiss(animated: true, completion: nil)
    }
}
