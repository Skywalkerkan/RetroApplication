//
//  QRView.swift
//  RetroApp
//
//  Created by Erkan on 6.08.2024.
//


import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    var sessionId: String
    
    var body: some View {
        VStack {
            if let qrImage = generateQRCode(from: sessionId) {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                Text("QR kod oluşturulamadı.")
            }
        }
        .padding()
    }

    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = string.data(using: .ascii)

        filter.setValue(data, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage else { return nil }
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
