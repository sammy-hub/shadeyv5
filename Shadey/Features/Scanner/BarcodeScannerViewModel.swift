import AVFoundation
import Foundation
import Observation

@MainActor
@Observable
final class BarcodeScannerViewModel {
    var isAuthorized: Bool = false
    var scannedCode: String?
    var errorMessage: String?

    func requestAccess() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        isAuthorized = granted
        if !granted {
            errorMessage = "Camera access is required to scan barcodes."
        }
    }

    func handleScanned(code: String) {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if scannedCode == trimmed {
            return
        }
        scannedCode = trimmed
    }

    func resetScan() {
        scannedCode = nil
        errorMessage = nil
    }
}
