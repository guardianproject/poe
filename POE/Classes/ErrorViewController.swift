//
//  ErrorViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 04.04.17.
//
//

import UIKit

public class ErrorViewController: XibViewController, POEDelegate {

    // MARK: - POEDelegate pass-through

    public func introFinished(_ useBridge: Bool) {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.introFinished(useBridge)
        }
    }

    public func userFinishedConnecting() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.userFinishedConnecting()
        }
    }
}
