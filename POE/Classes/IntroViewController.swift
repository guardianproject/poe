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
    @IBOutlet weak var useABridgeBt: UIButton!
    @IBOutlet weak var continueWithoutBt: UIButton!


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
            useABridgeBt.contentHorizontalAlignment = .right
            continueWithoutBt.contentHorizontalAlignment = .left
        }
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

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
        Callback for the "Use a Bridge" and "Continue Without" buttons.
     */
    @IBAction func finish(_ sender: UIButton) {
        if let presenter = presentingViewController as? POEDelegate {
            presenter.introFinished(sender == useABridgeBt)
        }
    }

    // MARK: - UIPageViewController delegate methods

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController]) {

        let index = modelController.indexOfViewController(pendingViewControllers[0])

        pageControl.currentPage = index

        let isBridgePage = index > 1

        pageControl.isHidden = isBridgePage
        nextPageBt.isHidden = isBridgePage
        useABridgeBt.isHidden = !isBridgePage
        continueWithoutBt.isHidden = !isBridgePage
    }


    public func pageViewController(_ pageViewController: UIPageViewController,
                                   spineLocationFor orientation: UIInterfaceOrientation)
        -> UIPageViewController.SpineLocation {

        let currentViewController = self.pageViewController!.viewControllers![0]
        self.pageViewController!.setViewControllers([currentViewController], direction: .forward,
                                                    animated: true, completion: {done in })

        self.pageViewController!.isDoubleSided = false
        return .min
    }

    // MARK: - private methods

    /**
        Jump to a ViewController of a given index.
     
        Fetches the proper ViewController, calculates the animation direction.
     */
    private func jumpToPage(_ index: Int) {
        var current :Int = 0

        if let viewControllers = pageViewController?.viewControllers {
            if viewControllers.count > 0 {
                current = modelController.indexOfViewController(viewControllers[0])

                if current == NSNotFound {
                    current = 0
                }
            }
        }

        if let next = modelController.viewControllerAtIndex(index) {
            pageViewController(pageViewController!, willTransitionTo: [next])

            let direction: UIPageViewController.NavigationDirection = current < index
                ? .forward
                : .reverse

            pageViewController?.setViewControllers([next],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: nil)
        }
    }
}
