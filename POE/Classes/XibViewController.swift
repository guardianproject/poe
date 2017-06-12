//
//  XibViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 24.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit
import Localize

/**
    Base class which initializes by default with a XIB/NIB of the same name as the child class.
 
    See
    - [Load assets from bundle resources in Cocoapods](https://the-nerd.be/2015/08/07/load-assets-from-bundle-resources-in-cocoapods/)
    - [Get ClassName without referencing self](http://stackoverflow.com/questions/31735429/get-classname-without-referencing-self)
 */
public class XibViewController: UIViewController, POEDelegate {

    // MARK: - Static

    private static var bundle: Bundle?

    private var autoKeyboardHandling = false
    private var scrollView: UIScrollView?

    public static func getBundle() -> Bundle {
        if bundle == nil {
            let frameworkBundle = Bundle(for: XibViewController.classForCoder())

            // CocoaPods manages to move all resources into a bundle inside the framework's bundle,
            // which we pick here.
            bundle = Bundle(url: (frameworkBundle.url(forResource: "POE", withExtension: "bundle"))!)
        }

        return bundle!
    }


    // MARK: - UIViewController

    public init() {
        let bundle = XibViewController.getBundle()

        Localize.update(bundle: bundle)
        Localize.update(fileName: "Localizable")

        super.init(nibName: String(describing: type(of: self)), bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Replace standard font with our corporate design font: Roboto
        robotoIt()
    }

    /**
         Add handling of keyboard: Close keyboard, when user taps outside the currently focused field.

         Resize content, when keyboard shows, so input fields aren't hidden by keyboard.

         Use this instead of `super.viewDidLoad()`!

         - parameter scrollView: The UIScrollView which' insets shall be resized above the keyboard.
     */
    func viewDidLoad(useKeyboardHandling: UIScrollView?) {
        super.viewDidLoad()

        // Replace standard font with our corporate design font: Roboto
        robotoIt()

        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard)))

        autoKeyboardHandling = true
        scrollView = useKeyboardHandling
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if autoKeyboardHandling {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardDidShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: .UIKeyboardWillHide, object: nil)
        }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }


    // MARK: - Keyboard helper methods

    /**
        Selector as target to dismiss keyboard on outside taps.
    */
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func keyboardShown(_ notification: Notification) -> CGRect {
        var kbRect = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue

        if let scrollView = self.scrollView {
            kbRect = scrollView.convert(kbRect, from: nil)

            var insets = scrollView.contentInset
            insets.bottom = kbRect.size.height
            scrollView.contentInset = insets

            insets = scrollView.scrollIndicatorInsets
            insets.bottom = kbRect.size.height
            scrollView.scrollIndicatorInsets = insets
        }

        return kbRect
    }

    func keyboardHidden(_ notification: Notification) {
        if let scrollView = self.scrollView {
            var insets = scrollView.contentInset
            insets.bottom = 0
            scrollView.contentInset = insets

            insets = scrollView.scrollIndicatorInsets
            insets.bottom = 0
            scrollView.scrollIndicatorInsets = insets
        }
    }


    // MARK: - POEDelegate pass-through

    public func introFinished(_ useBridge: Bool) {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.introFinished(useBridge)
        }
    }

    public func bridgeConfigured(_ bridgesId: Int, customBridges: [String]) {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.bridgeConfigured(bridgesId, customBridges: customBridges)
        }
    }

    public func changeSettings() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.changeSettings()
        }
    }

    public func userFinishedConnecting() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.userFinishedConnecting()
        }
    }

    public func localeUpdated(_ localeId: String) {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.localeUpdated(localeId)
        }
    }
}
