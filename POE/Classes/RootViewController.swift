//
//  RootViewController.swift
//  POE
//
//  Created by Benjamin Erhart on 22.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

public class RootViewController: XibViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController?

    @IBOutlet weak var pageControl: UIPageControl!

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        self.pageViewController!.view.frame = self.view.bounds
            .insetBy(dx: 0, dy: 25).offsetBy(dx: 0, dy: -25)

        self.pageViewController!.didMove(toParentViewController: self)

        // Replace standard font with our corporate design font: Roboto
        robotoIt()
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

    @IBAction func nextPage() {
        var nextIndex = 0

        if let dataViewController = pageViewController?.viewControllers?[0] {
            let index = modelController.indexOfViewController(dataViewController as! DataViewController)

            if index == NSNotFound || index >= modelController.pageData.count - 1 {
                nextIndex = 0
            }
            else {
                nextIndex = index + 1
            }
        }

        let pendingViewControllers: [UIViewController] = [modelController.viewControllerAtIndex(nextIndex)!]

        pageViewController(pageViewController!, willTransitionTo: pendingViewControllers)

        pageViewController?.setViewControllers(pendingViewControllers, direction: .forward,
                                               animated: true, completion: nil)
    }
    
    // MARK: - UIPageViewController delegate methods

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController]) {

        pageControl.currentPage = modelController.indexOfViewController(pendingViewControllers[0] as! DataViewController)
    }


    public func pageViewController(_ pageViewController: UIPageViewController,
                                   spineLocationFor orientation: UIInterfaceOrientation)
        -> UIPageViewControllerSpineLocation {

        let currentViewController = self.pageViewController!.viewControllers![0]
        let viewControllers = [currentViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

        self.pageViewController!.isDoubleSided = false
        return .min
    }
}
