import AVFoundation
import SwiftUI
import UIKit

struct BarcodeScannerView: UIViewRepresentable {
    let onCodeScanned: (String) -> Void

    @MainActor
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        context.coordinator.configureSession(in: view)
        return view
    }

    @MainActor
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.updateFrame(in: uiView)
        if !context.coordinator.isRunning {
            context.coordinator.startSession()
        }
    }

    @MainActor
    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.stopSession()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCodeScanned: onCodeScanned)
    }

    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        private let onCodeScanned: (String) -> Void
        private let session = AVCaptureSession()
        private let metadataOutput = AVCaptureMetadataOutput()
        private var previewLayer: AVCaptureVideoPreviewLayer?
        private(set) var isRunning = false
        private var isConfigured = false
        private let desiredTypes: [AVMetadataObject.ObjectType] = [
            .ean8,
            .ean13,
            .upce,
            .code39,
            .code128
        ]

        init(onCodeScanned: @escaping (String) -> Void) {
            self.onCodeScanned = onCodeScanned
            super.init()
        }

        @MainActor
        func configureSession(in view: UIView) {
            guard !isConfigured else {
                updateFrame(in: view)
                return
            }
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device) else {
                return
            }

            session.beginConfiguration()
            defer { session.commitConfiguration() }

            if session.canAddInput(input) {
                session.addInput(input)
            }

            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: nil)
                let supported = Set(metadataOutput.availableMetadataObjectTypes)
                let filtered = desiredTypes.filter { supported.contains($0) }
                metadataOutput.metadataObjectTypes = filtered.isEmpty ? metadataOutput.availableMetadataObjectTypes : filtered
            }

            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer.videoGravity = .resizeAspectFill
            layer.frame = view.bounds
            view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            view.layer.addSublayer(layer)
            previewLayer = layer
            isConfigured = true
        }

        @MainActor
        func updateFrame(in view: UIView) {
            previewLayer?.frame = view.bounds
        }

        func startSession() {
            guard isConfigured, !isRunning else { return }
            session.startRunning()
            isRunning = true
        }

        func stopSession() {
            guard isRunning else { return }
            session.stopRunning()
            isRunning = false
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
                  let code = object.stringValue else {
                return
            }
            stopSession()
            onCodeScanned(code)
        }
    }
}
