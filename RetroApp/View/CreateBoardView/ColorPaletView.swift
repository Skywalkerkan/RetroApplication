//
//  ColorPaletView.swift
//  RetroApp
//
//  Created by Erkan on 12.08.2024.
//

import SwiftUI

struct ColorPaletteView: View {
    
    let images: [String] = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"
    ]
    
    @Binding var selectedIndex: Int
    @Environment(\.presentationMode) var presentationMode
    
    let padding: CGFloat = 30
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ForEach(0..<images.count / 3, id: \.self) { rowIndex in
                    HStack(spacing: 16) {
                        ForEach(0..<3) { columnIndex in
                            let index = rowIndex * 3 + columnIndex
                            let imageName = images[index]
                            
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width - (padding * 2) - (16 * 2)) / 3, height: (UIScreen.main.bounds.width - (padding * 2) - (16 * 2)) / 3)
                                .cornerRadius(8)
                                .clipped()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    print("Tapped image index: \(index)")
                                    selectedIndex = index
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .overlay(
                                    Group {
                                        if selectedIndex == index {
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.white)
                                                .padding(8)
                                        }
                                    }
                                )
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, padding)
            .padding(.vertical, 16)
            .navigationBarTitle("Renk Paleti Seçimi", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .padding(.leading, 10)
            })
        }
    }
}
