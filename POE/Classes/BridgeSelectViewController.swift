//
//  BridgeSelectViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 02.06.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

public class BridgeSelectViewController: XibViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {

    @IBOutlet weak var explanation: UITextView!
    @IBOutlet weak var tableView: UITableView!

    private var currentId: Int
    private var noBridgeId: Int?
    private var providedBridges = [Int : String]()
    private var customBridgeId: Int?

    private var ids = [Int]()

    private var labels = [String]()

    public init(currentId: Int, noBridgeId: NSNumber?, providedBridges: [Int : String]?, customBridgeId: NSNumber?) {
        self.currentId = currentId
        self.noBridgeId = noBridgeId?.intValue

        if providedBridges != nil {
            self.providedBridges = providedBridges!
        }

        self.customBridgeId = customBridgeId?.intValue

        if self.noBridgeId != nil {
            ids.append(self.noBridgeId!)
        }

        for bridge in self.providedBridges {
            ids.append(bridge.key)
        }

        if self.customBridgeId != nil {
            ids.append(self.customBridgeId!)
        }

        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bridgeCell")
    }

    /**
        Need to do localization here, so if user goes back and changes it, the change will propagate.
     */
    public override func viewWillAppear(_ animated: Bool) {
        explanation.text = "__BRIDGES_EXPLANATION__".localize(value: "bridges.torproject.org")

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

    // MARK: - Action methods

    @IBAction func changedBridge(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        let old = tableView.cellForRow(at:
            IndexPath(row: ids.index(of: currentId)!, section: indexPath.section))
        old?.accessoryType = .none

        currentId = ids[indexPath.row]

        let new = tableView.cellForRow(at: indexPath)
        new?.accessoryType = .checkmark

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UINavigationBarDelegate

    /**
        Needed, so the UINavigationBar has proper height of 64px instead of 44px, even without a 
        UINavigationController.
     */
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
