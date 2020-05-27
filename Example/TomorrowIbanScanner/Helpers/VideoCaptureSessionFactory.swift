//
//  VideoCaptureSessionFactory.swift
//  TomorrowIbanScanner
//
//  Created by Pavel Stepanov on 21.04.20.
//  Copyright © 2020 Tomorrow GmbH. All rights reserved.
//

import AVFoundation

@available(iOS 13, *)
enum VideoCaptureSessionFactory {
    static func make(delegate: AVCaptureVideoDataOutputSampleBufferDelegate) -> AVCaptureSession? {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            debugPrint("No video device is available")
            return nil
        }

        let captureSession = AVCaptureSession()
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice), captureSession.canAddInput(videoInput) else {
            debugPrint("Could not get/add video input")
            return nil
        }
        captureSession.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue.global(qos: .userInitiated))
        guard captureSession.canAddOutput(videoOutput) else {
            debugPrint("Could not add output to capture session")
            return nil
        }
        captureSession.addOutput(videoOutput)

        return captureSession
    }
}
