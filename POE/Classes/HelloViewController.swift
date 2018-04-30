//
//  HelloViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 22.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit
import Localize

class HelloViewController: XibViewController {
    
    @IBOutlet weak var changeLangBt: UIButton!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Bad UX: Disabled this, since the user isn't able to come back
        // here, and OnionBrowser isn't influenced by this, anyway.
        changeLangBt.isHidden = true
    }

    @IBAction func changeLang() {
        let actionSheet = UIAlertController(title: "Change Language".localize(),
                                                 message: nil, preferredStyle: .actionSheet)

        for localeId in Localize.availableLanguages {
            let locale = NSLocale(localeIdentifier: localeId)

            actionSheet.addAction(UIAlertAction(
                title: locale.displayName(forKey: .identifier, value: localeId),
                style: .default,
                handler: { (action: UIAlertAction) in
                    Localize.update(language: localeId)
                }))
        }

        actionSheet.addAction(
            UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil))

        actionSheet.popoverPresentationController?.sourceView = changeLangBt
        actionSheet.popoverPresentationController?.sourceRect = changeLangBt.bounds

        present(actionSheet, animated: true, completion: nil)
    }
}
