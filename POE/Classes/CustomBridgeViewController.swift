//
//  CustomBridgeViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 05.06.17.
//
//

import UIKit
import KMPlaceholderTextView

class CustomBridgeViewController: XibViewController {

    @IBOutlet weak var explanationTV: UITextView!

    @IBOutlet weak var bridgesTV: KMPlaceholderTextView! {
        didSet {
            if #available(iOS 13, *) {
                bridgesTV.placeholderColor = .systemGray3
            }
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    var bridges = [String]()

    override func viewDidLoad() {
        super.viewDidLoad(useKeyboardHandling: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        explanationTV.text =
            "__CUSTOM_BRIDGE_EXPLANATION__".localize(value: "https://bridges.torproject.org/")

        bridgesTV.placeholder = "obfs4 172.0.0.1:1234 123456319E89E5C6223052AA525A192AFBC85D55 cert=GGGS1TX4R81m3r0HBl79wKy1OtPPNR2CZUIrHjkRg65Vc2VR8fOyo64f9kmT1UAFG7j0HQ iat-mode=0\n\nobfs4 172.0.0.2:4567 ABCDEF825B3B9EA6A98C83AC41F7099D67007EA5 cert=xpmQtKUqQ/6v5X7ijgYE/f03+l2/EuQ1dexjyUhh16wQlu/cpXUGalmhDIlhuiQPNEKmKw iat-mode=0\n\nobfs4 172.0.0.3:7890 098765AB960E5AC6A629C729434FF84FB5074EC2 cert=VW5f8+IBUWpPFxF+rsiVy2wXkyTQG7vEd+rHeN2jV5LIDNu8wMNEOqZXPwHdwMVEBdqXEw iat-mode=0"

        bridgesTV.text = bridges.joined(separator: "\n")

        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let vc = navigationController?.viewControllers,
            let bridgeVC = vc[(vc.count) - 1] as? BridgeSelectViewController {

            bridges = bridgesTV.text
                .components(separatedBy: "\n")
                .map({ bridge in bridge.trimmingCharacters(in: .whitespacesAndNewlines) })
                .filter({ (bridge) in !bridge.isEmpty && !bridge.hasPrefix("//") && !bridge.hasPrefix("#") })

            bridgeVC.currentId = bridges.count > 0 ? bridgeVC.customBridgeId! : bridgeVC.ids[0]
            bridgeVC.customBridges = bridges
        }
    }

    override func keyboardShown(_ notification: Notification) -> CGRect {
        let kbRect = super.keyboardShown(notification)

        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            self.bottom.constant = kbRect.size.height

            self.containerView.setNeedsUpdateConstraints()

            self.view.layoutIfNeeded()
        })

        return kbRect
    }

    override func keyboardHidden(_ notification: Notification) {
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, animations: {
            self.bottom.constant = 0
            
            self.containerView.setNeedsUpdateConstraints()

            self.view.layoutIfNeeded()
        })
    }
}
