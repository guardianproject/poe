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
        present(nextVC ?? introVC, animated: animated, completion: nil)
    }

    func introFinished(_ useBridge: Bool) {
        nextVC = errorVC

        dismiss(animated: true, completion: nil)
    }
}
