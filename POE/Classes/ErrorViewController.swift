//
//  ErrorViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 04.04.17.
//
//

import UIKit

public class ErrorViewController: XibViewController, POEDelegate {

    @IBOutlet weak var progressView: UIProgressView!

    /**
        Update the progress view with the given progress.

        Default is 50%.

        - parameter progress: The new progress value. See [UIProgressView#setProgress(_:animated:)](https://developer.apple.com/reference/uikit/uiprogressview/1619846-setprogress)
     */
    public func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: false)
    }

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
