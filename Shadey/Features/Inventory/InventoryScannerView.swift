import SwiftUI

struct InventoryScannerView: View {
    let store: InventoryStore

    @Environment(\.dismiss) private var dismiss
    @State private var scannerViewModel = BarcodeScannerViewModel()
    @State private var showingAddProduct = false

    var body: some View {
        NavigationStack {
            VStack {
                if scannerViewModel.isAuthorized {
                    BarcodeScannerView { code in
                        scannerViewModel.handleScanned(code: code)
                    }
                    .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
                    .overlay {
                        ScannerOverlayView()
                    }

                    if let scannedCode = scannerViewModel.scannedCode {
                        if let product = store.product(for: scannedCode) {
                            InventoryScanResultView(
                                store: store,
                                product: product,
                                scannedCode: scannedCode
                            ) {
                                scannerViewModel.resetScan()
                            }
                        } else {
                            InventoryScanNotFoundView(barcode: scannedCode) {
                                showingAddProduct = true
                            }
                        }
                    } else {
                        Text("Align the barcode within the frame to scan.")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .padding(DesignSystem.Spacing.large)
                    }
                } else {
                    Text("Camera access is required to scan barcodes.")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
            .padding(DesignSystem.Spacing.pagePadding)
            .navigationTitle("Scan Barcode")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .task {
                await scannerViewModel.requestAccess()
            }
            .sheet(isPresented: $showingAddProduct) {
                if let scannedCode = scannerViewModel.scannedCode {
                    ProductEditorView(store: store, prefilledBarcode: scannedCode)
                }
            }
        }
    }
}
