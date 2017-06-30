//
//  ScanQrViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 09.06.17.
//
//

import UIKit
import AVFoundation

class ScanQrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var videoView: UIView!

    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startReading()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopReading()
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {

        if metadataObjects.count > 0 {
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

            if metadataObj.type == AVMetadataObjectTypeQRCode {
                captureSession?.stopRunning()

                // They really had to use JSON for content encoding but with illegal single quotes instead
                // of double quotes as per JSON standard. Srly?
                if let data = metadataObj.stringValue.replacingOccurrences(of: "'", with: "\"").data(using: .utf8),
                    let newBridgesOpt = try? JSONSerialization.jsonObject(with: data, options: []) as? [String],
                    let newBridges = newBridgesOpt,
                    let vc = self.navigationController?.viewControllers,
                    let customVC = vc[(vc.count) - 2] as? CustomBridgeViewController {
                    
                    customVC.bridges = newBridges

                    navigationController?.popViewController(animated: true)
                }
                else {
                    alert(
                        "QR Code could not be decoded! Are you sure you scanned a QR code from bridges.torproject.org?".localize(),
                          handler: { UIAlertAction in
                            self.captureSession?.startRunning() })
                }
            }
        }
    }

    // MARK: - Private methods

    private func startReading() {

        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        do {
            let input = try AVCaptureDeviceInput.init(device: captureDevice)

            captureSession = AVCaptureSession()
            captureSession?.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = videoView.layer.bounds
            videoView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
        } catch {
            self.alert(
                "Camera access was not granted or QR Code scanning is not supported by your device.".localize(),
                handler: { UIAlertAction in
                    self.navigationController?.popViewController(animated: true) })
        }
    }

    private func stopReading() {
        if captureSession != nil {
            captureSession?.stopRunning()
            captureSession = nil
        }

        if videoPreviewLayer != nil {
            videoPreviewLayer?.removeFromSuperlayer()
            videoPreviewLayer = nil
        }
    }

    // MARK: - Internal methods

    private func alert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error".localize(),
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: handler))
        present(alert, animated: true, completion: nil)
    }
}
