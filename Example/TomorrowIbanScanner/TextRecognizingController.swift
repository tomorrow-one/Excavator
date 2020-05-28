//
//  TextRecognizingController.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 01.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import UIKit
import AVFoundation
import TomorrowIbanScanner

public final class TextRecognizingController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var captureRectView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    private var viewModel: IdentifierRecognizingViewModel!

    private var captureSession: AVCaptureSession!

    private var maskLayer: CALayer!
    private var dimLayer: CALayer!

    private var cropRectProportions: CGRect = .zero

    private var previewLayer: AVCaptureVideoPreviewLayer!

    public override var prefersStatusBarHidden: Bool { true }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard self.captureSession == nil else {
            return
        }

        guard let captureSession = VideoCaptureSessionFactory.make(delegate: self) else {
            showImageCaptureNotSupported()
            return
        }
        self.captureSession = captureSession
        self.captureSession.startRunning()

        configLayers()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard self.previewLayer != nil else {
            return
        }
        self.previewLayer.frame = self.view.frame
        configDimLayerMask()

        self.cropRectProportions = makeCropRectProportions()
    }

    private func bindViewModel() {
        self.viewModel.didSuccess = { [unowned self] value in
            switch value {
            case .email(let email):
                self.messageLabel.text = email
            case .iban(let iban):
                self.messageLabel.text = iban.value
            }
        }
        self.viewModel.didRecognizeMultipleResults = { [unowned self] item in
            self.present(AlertFactory.makeAlertController(item: item), animated: true)
        }
    }

    // MARK: - Appearance

    private  func configView() {
        self.view.backgroundColor = .black

        self.captureRectView.layer.cornerRadius = 8
        self.captureRectView.layer.borderWidth = 1
        self.captureRectView.layer.borderColor = UIColor(named: "always_white")!.cgColor
        self.captureRectView.clipsToBounds = false
        self.messageLabel.text = "We haven't discovered anything yet"
    }

    private func configLayers() {
        self.previewLayer = makePreviewLayer(captureSession: self.captureSession)
        self.view.layer.insertSublayer(self.previewLayer, at: 0)
        self.dimLayer = makeDimLayer()
        self.previewLayer.addSublayer(self.dimLayer)
    }

    private func makeDimLayer() -> CALayer {
        let dimLayer = CALayer()
        dimLayer.frame = self.view.layer.frame
        dimLayer.backgroundColor = UIColor.black.cgColor
        dimLayer.opacity = 0.4
        return dimLayer
    }

    private func makePreviewLayer(captureSession: AVCaptureSession) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.masksToBounds = false
        return previewLayer
    }

    private func configDimLayerMask() {
        self.captureRectView.superview?.setNeedsLayout()
        self.captureRectView.superview?.layoutIfNeeded()

        let path = CGMutablePath()

        let captureRect = self.view.convert(self.captureRectView.frame, from: self.captureRectView.superview)
        path.addRoundedRect(in: captureRect, cornerWidth: 8, cornerHeight: 8)
        path.addRect(CGRect(origin: .zero, size: self.view.frame.size))

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        self.dimLayer.mask = maskLayer
    }

    // MARK: - Helpers

    private func makeCropRectProportions() -> CGRect {
        let proportionalMinX = self.view.convert(self.captureRectView.frame.origin, from: self.captureRectView).x / self.view.bounds.width
        let proportionalWidth = self.captureRectView.frame.width / self.view.bounds.width
        let proportionalMinY = self.view.convert(self.captureRectView.frame.origin, from: self.captureRectView).y / self.view.bounds.height
        let proportionalHeight = self.captureRectView.frame.height / self.view.bounds.height
        return CGRect(x: proportionalMinX, y: proportionalMinY, width: proportionalWidth, height: proportionalHeight)
    }

    private func showImageCaptureNotSupported() {
        let okAction = AlertActionViewItem(title: "Understand",
                                           style: .default(isPreferred: false)) { [unowned self] in
            self.dismiss(animated: true)
        }
        let item = AlertControllerViewItem(title: NSLocalizedString("transfer.iban_scanner.not_supported", comment: ""),
                                           message: nil,
                                           actions: [okAction])
        self.present(AlertFactory.makeAlertController(item: item), animated: true)
    }
}

extension TextRecognizingController: AVCaptureVideoDataOutputSampleBufferDelegate {

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard !self.viewModel.inProgess else {
            return
        }
        guard let scaledImage = CIImageHelper.make(from: sampleBuffer, targetProportionRect: self.cropRectProportions) else {
            return
        }

        DispatchQueue.main.async {
            self.viewModel!.tryRecognizeIdentifierInImage(scaledImage)
        }
    }
}

extension TextRecognizingController {
    public static func make(extractors: [ValueExtracting] = [IbanExtractor(), EmailExtractor()]) -> TextRecognizingController {
        let controller = TextRecognizingController()
        controller.viewModel = IdentifierRecognizingViewModel(extractors: extractors)
        return controller
    }
}
