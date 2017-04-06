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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var claimLb: UILabel!
    @IBOutlet weak var startBrowsingBt: UIButton!
    @IBOutlet weak var figureBt1: UIButton!
    @IBOutlet weak var figureBt2: UIButton!

    private static let claims = [
        NSLocalizedString("Normal people use Tor to protect their privacy from unscrupulous marketers and identity theives.", comment: ""),
        NSLocalizedString("Citizen journalists in China use Tor to write about local events to encourage social change and political reform.", comment: ""),
    ]

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.isHidden = true
        startBrowsingBt.isHidden = true
        startBrowsingBt.layer.borderWidth = 1
        startBrowsingBt.layer.borderColor = UIColor.white.cgColor
        startBrowsingBt.layer.cornerRadius = 20

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.showBusy()
        })
    }

    /**
        This will hide the activity indicator and instead show a label
        "Connected!" and a button "Start Browsing".
     */
    public func done() {
        self.activityIndicator.isHidden = true
        self.infoLb.text = NSLocalizedString("Connected!", comment: "")
        self.infoLb.isHidden = false
        self.claimLb.isHidden = true
        self.startBrowsingBt.isHidden = false
    }

    // MARK: - Action methods

    @IBAction func showClaim(_ sender: UIButton) {
        var text: String

        switch sender {
        case figureBt1:
            text = ConnectingViewController.claims[0]
        default:
            text = ConnectingViewController.claims[1]
        }

        claimLb.text = text
    }
    
    @IBAction func startBrowsing() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.connectingFinished()
        }
    }

    // MARK: - Private methods

    private func showBusy() {
        self.infoLb.isHidden = true
        self.activityIndicator.isHidden = false
    }
}
