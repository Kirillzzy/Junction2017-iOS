//
//  CameraViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

  var previewLayer: AVCaptureVideoPreviewLayer!
  var captureSession: AVCaptureSession!
  var readed: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    if let captureDevice = AVCaptureDevice.default(for: .video) {
      do {
        let input = try AVCaptureDeviceInput(device: captureDevice)
        captureSession = AVCaptureSession()
        captureSession.addInput(input)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)

        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13, .ean8, .code39]
        captureSession.startRunning()

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
      } catch {
        print("Unknown device")
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if captureSession?.isRunning == false {
      readed = false
      captureSession.startRunning()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if captureSession?.isRunning == true {
      captureSession.stopRunning()
    }
  }

  func metadataOutput(_ output: AVCaptureMetadataOutput,
                      didOutput metadataObjects: [AVMetadataObject],
                      from connection: AVCaptureConnection) {
    guard metadataObjects.count != 0 else { return }
    guard let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
      readed == false else { return }
    guard let stringCodeValue = metadataObject.stringValue else { return }
    readed = true
    barCodeFound(stringCodeValue)
  }

  func barCodeFound(_ stringCode: String) {
    guard let presentViewController = mainStoryboad.instantiateViewController(withIdentifier: "ContractViewController")
      as? ContractViewController else { return }
    presentViewController.scannedQrString = stringCode
    navigationController?.pushViewController(presentViewController, animated: true)
  }
}
