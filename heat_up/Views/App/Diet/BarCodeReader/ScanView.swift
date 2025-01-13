import SwiftUI

struct ScanView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var scannedCode: String?
    @State private var errorMessage: String = ""
    @State private var isAlertPresented = false
    @State private var isCommodityViewPresented = false
    @State private var shouldRestartScanning = false // New state
    @StateObject private var viewModel = CommodityViewModel()

    var body: some View {
        ZStack {
            ScannerView(scannedCode: $scannedCode, errorMessage: $errorMessage, shouldRestartScanning: $shouldRestartScanning)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding(.bottom, 20)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text("Barcode Scanned"),
                message: Text("Decoded Value: \(scannedCode ?? "Unknown")"),
                dismissButton: .default(Text("Fetch Data"), action: {
                    if let code = scannedCode {
                        viewModel.fetchCommodityData(barcode: code)
                    }
                })
            )
        }
        .onChange(of: scannedCode) { _, newValue in
            if newValue != nil {
                isAlertPresented = true
            }
        }
        .onReceive(viewModel.$product) { product in
            if product != nil {
                isCommodityViewPresented = true
            }
        }
        .onReceive(viewModel.$errorMessage) { message in
            if let message = message, !message.isEmpty {
                errorMessage = message
            }
        }
        .sheet(isPresented: $isCommodityViewPresented, onDismiss: {
            scannedCode = nil
            shouldRestartScanning = true // Restart scanning
        }) {
            if let product = viewModel.product {
                CommodityView(commodity: product)
            }
        }
    }
}

struct ScanButtonView: View {
    @State private var isScanning = false

    var body: some View {
        Button("Start Scanning") {
            isScanning = true
        }
        .sheet(isPresented: $isScanning) {
            ScanView()
        }
    }
}

#Preview {
    ScanButtonView()
}
