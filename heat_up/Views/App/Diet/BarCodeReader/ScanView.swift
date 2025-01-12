//
//  TestView.swift
//  heat_up
//
//  Created by marat orozaliev on 11/1/2025.
//
import SwiftUI

struct ScanView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var scannedCode: String?
    @State private var errorMessage: String = "" // New state for error messages
    @State private var isAlertPresented = false

    var body: some View {
        ZStack {
            ScannerView(scannedCode: $scannedCode, errorMessage: $errorMessage)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text(errorMessage) // Display the error message
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
                dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
        .onChange(of: scannedCode) { oldValue, newValue in
            if newValue != nil {
                isAlertPresented = true
            }
        }
    }
}
