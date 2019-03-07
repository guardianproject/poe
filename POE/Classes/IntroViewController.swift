//
//  IntroViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 22.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

public class IntroViewController: XibViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextPageBt: UIButton!
    @IBOutlet weak var useABridgeLb: UILabel!
    @IBOutlet weak var continueWithoutLb: UILabel!


    override public func viewDidLoad() {
        super.viewDidLoad()

        // Configure the page view controller and add it as a child view controller.
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal, options: nil)
        pageViewController!.delegate = self

        jumpToPage(0)

        pageViewController!.dataSource = modelController

        addChild(pageViewController!)
        view.addSubview(pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible
        // around the edges of the pages.
        pageViewController!.view.frame = self.view.bounds
            .insetBy(dx: 0, dy: 25).offsetBy(dx: 0, dy: -25)

        pageViewController!.didMove(toParent: self)

        // Unfortunately, this has to be done programatically.
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            nextPageBt.contentHorizontalAlignment = .left
        }
    }

    lazy var modelController = ModelController()

    // MARK: - Actions

    /**
        Callback for the "next page" (right chevron) button.
     */
    @IBAction func nextPage() {
        jumpToPage(pageControl.currentPage + 1)
    }

    /**
        Callback for a tap on the UIPageControl element.
     */
    @IBAction func pageChanged() {
        jumpToPage(pageControl.currentPage)
    }

    /**
     Callback for the "Use a Bridge" pseudo-button.
     */
    @IBAction func finishWithBridge() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.introFinished(true)
        }
    }

    /**
        Callback for the "Continue Without" pseudo-button.
     */
    @IBAction func finish() {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.introFinished(false)
        }
    }

    // MARK: - UIPageViewController delegate methods

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        if completed,
            let vc = pageViewController.viewControllers?.first {

            let index = modelController.indexOfViewController(vc)

            pageControl.currentPage = index

            let isBridgePage = index > 1

            pageControl.isHidden = isBridgePage
            nextPageBt.isHidden = isBridgePage
            useABridgeLb.isHidden = !isBridgePage
            continueWithoutLb.isHidden = !isBridgePage
        }
    }


    // MARK: - private methods

    /**
        Jump to a ViewController of a given index.
     
        Fetches the proper ViewController, calculates the animation direction.
     */
    private func jumpToPage(_ index: Int) {
        var current :Int = 0

        if let viewController = pageViewController?.viewControllers?.first {
            current = modelController.indexOfViewController(viewController)

            if current == NSNotFound {
                current = 0
            }
        }

        if let next = modelController.viewControllerAtIndex(index) {
            let direction: UIPageViewController.NavigationDirection = current < index
                ? .forward
                : .reverse

            pageViewController?.setViewControllers([next], direction: direction, animated: true)

            pageViewController(pageViewController!, didFinishAnimating: false,
                               previousViewControllers: [], transitionCompleted: true)
        }
    }
}
