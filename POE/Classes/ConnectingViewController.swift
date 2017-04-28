//
//  ConnectingViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 06.04.17.
//
//

import UIKit

public class ConnectingViewController: XibViewController {

    @IBOutlet weak var infoLb: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var claimLb: UILabel!
    @IBOutlet weak var startBrowsingBt: UIButton!
    @IBOutlet weak var figureBt1: UIButton!
    @IBOutlet weak var figureBt2: UIButton!

    public var autoClose = false

    private var firstClaim = 0

    private static let claims = [
        "__CLAIM_1__".localize(),
        "__CLAIM_2__".localize(),
        "__CLAIM_3__".localize(),
    ]

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        progressView.isHidden = true

        startBrowsingBt.isHidden = true
        startBrowsingBt.layer.borderWidth = 1
        startBrowsingBt.layer.borderColor = UIColor.white.cgColor
        startBrowsingBt.layer.cornerRadius = 20

        showClaim(nil)
    }

    /**
        Hide the info label, the "Start Browsing" button, update the progress view with 0
        progress and show the claims.
     */
    public func connectingStarted() {
        updateProgress(0)
    }

    /**
        Hide the info label, the "Start Browsing" button, update the progress view with the given
        progress and show the claims.
     
        - parameter progress: The new progress value. See [UIProgressView#setProgress(_:animated:)](https://developer.apple.com/reference/uikit/uiprogressview/1619846-setprogress)
     */
    public func updateProgress(_ progress: Float) {
        infoLb.isHidden = true

        progressView.setProgress(progress, animated: true)
        progressView.isHidden = false

        startBrowsingBt.isHidden = true

        claimLb.isHidden = false
    }

    /**
        Hide the progress view and the claims and instead show a label
        "Connected!" and a button "Start Browsing".
     
        If `autoClose` is enabled and `presenter` implements `POEDelegate`, send 
        `userFinishedConnecting` immediately.
     */
    public func connectingFinished() {
        if autoClose && (presentingViewController as? POEDelegate) != nil {
            startBrowsing()

            return
        }

        progressView.isHidden = true

        infoLb.text = "Connected!".localize()
        infoLb.isHidden = false

        claimLb.isHidden = true

        startBrowsingBt.isHidden = false
    }

    // MARK: - Action methods

    @IBAction func showClaim(_ sender: UIButton?) {
        var text: String

        if let figure = sender {
            switch figure {
            case figureBt1:
                text = ConnectingViewController.claims[firstClaim == 1 ? 0 : 1]
            default:
                text = ConnectingViewController.claims[firstClaim == 2 ? 0 : 2]
            }
        }
        else {
            firstClaim = Int(arc4random_uniform(UInt32(ConnectingViewController.claims.count)))
            text = ConnectingViewController.claims[firstClaim]
        }

        claimLb.text = text
    }
    
    @IBAction func startBrowsing() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.userFinishedConnecting()
        }
    }
}
