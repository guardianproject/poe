//
//  CustomBridgeViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 05.06.17.
//
//

import UIKit
import KMPlaceholderTextView
import QRCodeReader
import AVFoundation

class CustomBridgeViewController: XibViewController, UINavigationBarDelegate, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var explanationTV: UITextView!

    @IBOutlet weak var bridgesTV: KMPlaceholderTextView!

    var isEdited = false

    var bridges = [String]()

    private var viaQrCode = false

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }

        return QRCodeReaderViewController(builder: builder)
    }()

    override func viewWillAppear(_ animated: Bool) {
        explanationTV.text =
            "__CUSTOM_BRIDGE_EXPLANATION__".localize(value: "https://bridges.torproject.org/")

        bridgesTV.placeholder = "obfs4 172.0.0.1:1234 123456319E89E5C6223052AA525A192AFBC85D55 cert=GGGS1TX4R81m3r0HBl79wKy1OtPPNR2CZUIrHjkRg65Vc2VR8fOyo64f9kmT1UAFG7j0HQ iat-mode=0\n\nobfs4 172.0.0.2:4567 ABCDEF825B3B9EA6A98C83AC41F7099D67007EA5 cert=xpmQtKUqQ/6v5X7ijgYE/f03+l2/EuQ1dexjyUhh16wQlu/cpXUGalmhDIlhuiQPNEKmKw iat-mode=0\n\nobfs4 172.0.0.3:7890 098765AB960E5AC6A629C729434FF84FB5074EC2 cert=VW5f8+IBUWpPFxF+rsiVy2wXkyTQG7vEd+rHeN2jV5LIDNu8wMNEOqZXPwHdwMVEBdqXEw iat-mode=0"

        bridgesTV.text = bridges.joined(separator: "\n")

        // If we aquired these via a QR code, the isEdited check will fail in #back, if we don't
        // change the bridges variable here. Ugly design, but hard to do it in another way.
        if viaQrCode {
            viaQrCode = false
            bridges = [String]()
        }

        super.viewWillAppear(animated)
    }

    // MARK: - Actions

    @IBAction func back(_ sender: Any) {
        let oldBridges = bridges

        bridges = bridgesTV.text
            .components(separatedBy: "\n")
            .map({ bridge in bridge.trimmingCharacters(in: .whitespacesAndNewlines) })
            .filter({ (bridge) in !bridge.isEmpty && !bridge.hasPrefix("//") && !bridge.hasPrefix("#") })

        isEdited = oldBridges != bridges

        dismiss(animated: true, completion: nil)
    }

    @IBAction func scanQr(_ sender: Any) {
        let supportsQr = try? QRCodeReader.supportsMetadataObjectTypes([AVMetadataObjectTypeQRCode])
        
        if supportsQr ?? false && QRCodeReader.isAvailable() {
            readerVC.delegate = self

            readerVC.modalPresentationStyle = .formSheet
            present(readerVC, animated: true, completion: nil)
        }
        else {
            alert("Camera access was not granted or QRCode scanning is not supported by your device.".localize())
        }
    }

    // MARK: - UINavigationBarDelegate

    /**
     Needed, so the UINavigationBar has proper height of 64px instead of 44px, even without a
     UINavigationController.
     */
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    // MARK: - QRCodeReaderViewControllerDelegate

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)

        // They really had to use JSON for content encoding but with illegal single quotes instead
        // of double quotes as per JSON standard. Srly?
        if let data = result.value.replacingOccurrences(of: "'", with: "\"").data(using: .utf8),
            let newBridgesOpt = try? JSONSerialization.jsonObject(with: data, options: []) as? [String],
            let newBridges = newBridgesOpt {
                bridges = newBridges
                viaQrCode = true
        }
        else {
            alert("QR Code could not be decoded! Are you sure, you scanned a QR code from bridges.torproject.org?".localize())
        }
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }

    // MARK: - Internal methods

    private func alert(_ message: String) {
        let alert = UIAlertController(
            title: "Error".localize(),
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
