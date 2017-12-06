//
//  ConnectingViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 06.04.17.
//
//

import UIKit
import UIColor_HexRGB

public class ConnectingViewController: XibViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var settingsBt: UIButton!
    @IBOutlet weak var infoLb: UILabel!
    @IBOutlet weak var claimLb: UILabel!
    @IBOutlet weak var startBrowsingBt: UIButton!
    @IBOutlet weak var image: UIImageView!

    @objc public var autoClose = false

    private var lastClaim: Int?

    private var refresh: Timer?

    private static let claims = [
        [
            "text": "__CLAIM_1__".localize(),
            "text_color": "FFFFFF",
            "background_color": "7D4698",
            "image": "group",
        ],
        [
            "text": "__CLAIM_2__".localize(),
            "text_color": "000000",
            "background_color": "CDEA52",
            "image": "people",
        ],
        [
            "text": "__CLAIM_3__".localize(),
            "text_color": "FFFFFF",
            "background_color": "4A4A4A",
            "image": "facebook",
        ],
        [
            "text": "__CLAIM_4__".localize(),
            "text_color": "FFFFFF",
            "background_color": "2196F3",
            "image": "activist",
        ],
        [
            "text": "__CLAIM_5__".localize(),
            "text_color": "FFFFFF",
            "background_color": "EE8B3C",
            "image": "blogger",
        ],
        [
            "text": "__CLAIM_6__".localize(),
            "text_color": "000000",
            "background_color": "FFCFBF",
            "image": "journalist",
        ],
        [
            "text": "__CLAIM_7__".localize(),
            "text_color": "000000",
            "background_color": "FFDE2A",
            "image": "business",
        ],
        [
            "text": "__CLAIM_8__".localize(),
            "text_color": "000000",
            "background_color": "69D5A1",
            "image": "worker",
        ],
    ]

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        progressView.isHidden = false

        settingsBt.isHidden = false

        startBrowsingBt.isHidden = true
        startBrowsingBt.layer.borderWidth = 1
        startBrowsingBt.layer.borderColor = UIColor.white.cgColor
        startBrowsingBt.layer.cornerRadius = 20

        showClaim(nil)
        refresh = Timer.scheduledTimer(timeInterval: 3, target: self,
                                       selector: #selector(showClaim), userInfo: nil, repeats: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        refresh?.invalidate()
        refresh = nil
    }

    /**
        Hide the info label, the "Start Browsing" button, update the progress view with 0
        progress and show the claims.
     */
    @objc public func connectingStarted() {
        infoLb.text = "We're connecting you.".localize()

        updateProgress(0)
    }

    /**
        Hide the info label, the "Start Browsing" button, update the progress view with the given
        progress and show the claims.
     
        - parameter progress: The new progress value. See [UIProgressView#setProgress(_:animated:)](https://developer.apple.com/reference/uikit/uiprogressview/1619846-setprogress)
     */
    @objc public func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
        progressView.isHidden = false

        settingsBt.isHidden = false

        startBrowsingBt.isHidden = true

        claimLb.isHidden = false
    }

    /**
        Hide the progress view and the claims and instead show a label
        "Connected!" and a button "Start Browsing".
     
        If `autoClose` is enabled and `presenter` implements `POEDelegate`, send 
        `userFinishedConnecting` immediately.
     */
    @objc public func connectingFinished() {
        if autoClose && (presentingViewController as? POEDelegate) != nil {
            startBrowsing()

            return
        }

        refresh?.invalidate()

        progressView.isHidden = true

        settingsBt.isHidden = true

        infoLb.text = "Connected!".localize()

        claimLb.isHidden = true

        startBrowsingBt.isHidden = false
    }

    // MARK: - Action methods

    @IBAction public override func changeSettings() {
        super.changeSettings()
    }

    @IBAction func startBrowsing() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.userFinishedConnecting()
        }
    }

    // MARK: - Private methods

    @objc private func showClaim(_ timer: Timer?) {
        var nextClaim: Int

// FOR DEBUGGING: Show all in a row.
//
//        if lastClaim == nil || lastClaim! >= ConnectingViewController.claims.count - 1 {
//            nextClaim = 0
//        }
//        else {
//            nextClaim = lastClaim! + 1
//        }

        repeat {
            nextClaim = Int(arc4random_uniform(UInt32(ConnectingViewController.claims.count)))
        } while nextClaim == lastClaim

        lastClaim = nextClaim

        let data = ConnectingViewController.claims[nextClaim]

        self.claimLb.text = data["text"]
        self.claimLb.textColor = UIColor.init(hex: data["text_color"])
        self.view.backgroundColor = UIColor.init(hex: data["background_color"])
        self.image.image = UIImage.init(named: data["image"]!,
                                        in: XibViewController.getBundle(), compatibleWith: nil)
    }
}
