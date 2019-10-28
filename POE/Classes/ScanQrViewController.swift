//
//  ScanQrViewController.swift
//  Pods
//
//  Created by Benjamin Erhart on 09.06.17.
//
//

import UIKit
import AVFoundation

class ScanQrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var videoView: UIView!

    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    private lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()

        picker.sourceType = .photoLibrary
        picker.delegate = self

        return picker
    }()

    private lazy var detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startReading()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopReading()
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    /**
     BUGFIX: Signature of method changed in Swift 4, without notifications.
     No migration assistance either.

     See https://stackoverflow.com/questions/46639519/avcapturemetadataoutputobjectsdelegate-not-called-in-swift-4-for-qr-scanner
    */
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput
        metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        if metadataObjects.count > 0,
            let metadata = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            metadata.type == .qr {

            captureSession?.stopRunning()

            tryDecode(metadata.stringValue)
        }
    }


    // MARK: Actions

    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        captureSession?.stopRunning()

        picker.popoverPresentationController?.barButtonItem = sender

        present(picker, animated: true)
    }


    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        var raw = ""

        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage,
            let ciImage = image.ciImage ?? (image.cgImage != nil ? CIImage(cgImage: image.cgImage!) : nil) {

            let features = detector?.features(in: ciImage)

            for feature in features as? [CIQRCodeFeature] ?? [] {
                raw += feature.messageString ?? ""
            }
        }

        tryDecode(raw)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)

        captureSession?.startRunning()
    }


    // MARK: Private methods

    private func startReading() {

        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)

                captureSession = AVCaptureSession()

                if let captureSession = captureSession {
                    captureSession.addInput(input)

                    let captureMetadataOutput = AVCaptureMetadataOutput()
                    captureSession.addOutput(captureMetadataOutput)
                    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    captureMetadataOutput.metadataObjectTypes = [.qr]

                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

                    if let videoPreviewLayer = videoPreviewLayer {
                        videoPreviewLayer.videoGravity = .resizeAspectFill
                        videoPreviewLayer.frame = videoView.layer.bounds
                        videoView.layer.addSublayer(videoPreviewLayer)

                        captureSession.startRunning()

                        return
                    }
                }
            } catch {
                // Just fall thru to alert.
            }
        }

        let warning = UILabel(frame: .zero)
        warning.text = "Camera access was not granted or QR Code scanning is not supported by your device.".localize()
        warning.translatesAutoresizingMaskIntoConstraints = false
        warning.numberOfLines = 0
        warning.textAlignment = .center
        warning.textColor = .white // hard white, will always look better on dark purple.

        videoView.addSubview(warning)
        warning.leadingAnchor.constraint(equalTo: videoView.leadingAnchor, constant: 16).isActive = true
        warning.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -16).isActive = true
        warning.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 16).isActive = true
        warning.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -16).isActive = true
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

    private func tryDecode(_ raw: String?) {
        // They really had to use JSON for content encoding but with illegal single quotes instead
        // of double quotes as per JSON standard. Srsly?
        if let data = raw?.replacingOccurrences(of: "'", with: "\"").data(using: .utf8),
            let newBridges = try? JSONSerialization.jsonObject(with: data, options: []) as? [String],
            let vc = self.navigationController?.viewControllers,
            let customVC = vc[(vc.count) - 2] as? CustomBridgeViewController {

            customVC.bridges = newBridges

            navigationController?.popViewController(animated: true)
        }
        else {
            alert("QR Code could not be decoded! Are you sure you scanned a QR code from bridges.torproject.org?".localize())
            { _ in
                self.captureSession?.startRunning()
            }
        }
    }

    private func alert(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: "Error".localize(),
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: handler))
        alert.view.tintColor = .poeAccentLight
        present(alert, animated: true, completion: nil)
    }
}
