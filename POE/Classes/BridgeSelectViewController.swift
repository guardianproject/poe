//
//  BridgeSelectViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 02.06.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

public class BridgeSelectViewController: XibViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var explanationTV: UITextView!
    @IBOutlet weak var tableView: UITableView!

    var currentId: Int = 0
    private var noBridgeId: Int?
    private var providedBridges = [Int : String]()
    var customBridgeId: Int?

    var ids = [Int]()

    private var labels = [String]()

    var customBridges = [String]()

    var delegate: POEDelegate?

    @objc public static func instantiate(
        currentId: Int, noBridgeId: NSNumber?, providedBridges: [Int : String]?,
        customBridgeId: NSNumber?, customBridges: [String]?,
        delegate: POEDelegate? = nil) -> UINavigationController {

        let storyboard = UIStoryboard.init(name: "Bridges", bundle: XibViewController.getBundle())
        let navC = storyboard.instantiateInitialViewController() as! UINavigationController
        let bridgeVC = navC.topViewController as! BridgeSelectViewController

        bridgeVC.currentId = currentId

        bridgeVC.noBridgeId = noBridgeId?.intValue

        if providedBridges != nil {
            bridgeVC.providedBridges = providedBridges!
        }

        bridgeVC.customBridgeId = customBridgeId?.intValue

        if bridgeVC.noBridgeId != nil {
            bridgeVC.ids.append(bridgeVC.noBridgeId!)
        }

        for bridge in bridgeVC.providedBridges {
            bridgeVC.ids.append(bridge.key)
        }

        if bridgeVC.customBridgeId != nil {
            bridgeVC.ids.append(bridgeVC.customBridgeId!)
        }

        if customBridges != nil {
            bridgeVC.customBridges = customBridges!
        }

        bridgeVC.delegate = delegate

        return navC
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
        Need to do localization here, so if user goes back and changes it, the change will propagate.
     */
    public override func viewWillAppear(_ animated: Bool) {
        explanationTV.text = "__BRIDGES_EXPLANATION__".localize(value: "bridges.torproject.org")

        labels.removeAll()

        if noBridgeId != nil {
            labels.append("No Bridges: Directly Connect to Tor".localize())
        }

        for bridge in providedBridges {
            labels.append("Provided Bridges: %".localize(value: bridge.value))
        }

        if customBridgeId != nil {
            labels.append("Custom Bridges".localize())
        }

        tableView.reloadData()

        super.viewWillAppear(animated)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let customVC = segue.destination as? CustomBridgeViewController {
            customVC.bridges = customBridges
        }
    }

    // MARK: - Action methods

    @IBAction func changedBridge(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        if let delegate = delegate ?? presentingViewController as? POEDelegate {
            delegate.bridgeConfigured(currentId, customBridges: customBridges)
        }
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bridgeCell", for: indexPath)

        cell.textLabel?.text = labels[indexPath.row]
        cell.accessoryType = ids[indexPath.row] == currentId ? .checkmark : .none

        return cell
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ids[indexPath.row] == self.customBridgeId {
            performSegue(withIdentifier: "customBridgesSegue", sender: self)
        }
        else {
            let old = tableView.cellForRow(at:
                IndexPath(row: ids.firstIndex(of: currentId)!, section: indexPath.section))
            old?.accessoryType = .none

            currentId = ids[indexPath.row]

            let new = tableView.cellForRow(at: indexPath)
            new?.accessoryType = .checkmark

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
