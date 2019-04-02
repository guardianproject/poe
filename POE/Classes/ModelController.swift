//
//  ModelController.swift
//  POE
//
//  Created by Benjamin Erhart on 22.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pages: [UIViewController] = [
        HelloViewController(),
        NotrackViewController(),
        BridgeViewController(),
    ]


    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        // Return the data view controller for the given index.
        if (pages.count == 0) || (index >= pages.count) {
            return nil
        }

        return pages[index]
    }

    func indexOfViewController(_ viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pages.firstIndex(of: viewController) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var index = indexOfViewController(viewController)

        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var index = indexOfViewController(viewController)

        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == pages.count {
            return nil
        }

        return self.viewControllerAtIndex(index)
    }
}
