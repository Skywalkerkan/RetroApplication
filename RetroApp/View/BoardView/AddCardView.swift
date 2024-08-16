//
//  AddCardView.swift
//  RetroApp
//
//  Created by Erkan on 7.08.2024.
//

import SwiftUI

struct AddCardView: View {
    
    @State var cardDescription: String = ""
    @State private var isEditing: Bool = false

    var onSave: (String) -> Void
    var onCloseCard: () -> Void

    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

    @State private var isLandscape: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack (spacing: 0){
                TextEditor(text: $cardDescription)
                    .frame(minHeight: 28, alignment: .leading)
                    .frame(maxHeight: isLandscape ? 28 : 120)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .background(Color.white)
                    .onTapGesture {
                        cardDescription = ""
                    }
                    .onChange(of: cardDescription) { newValue in
                        if newValue.isEmpty {
                            isEditing = false
                        }
                    }
                HStack {
                    Spacer()
                    
                    Button(action: {
                        onCloseCard()
                    }) {
                        Image(systemName: "xmark")
                            .frame(width: 25, height: 25)
                            .foregroundColor(.gray)
                    }
                    
                    Button {
                        onSave(cardDescription)
                    } label: {
                        Text(" Save ")
                            .frame(height: 25)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(2)
                    }
                }
                .padding(.bottom, 6)
                .frame(height: 27)
                .padding(.trailing, 8)
            }
            .frame(width: 268)
            .background(Color.white)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(red: 25/255, green: 158/255, blue: 36/255), lineWidth: 4)
            )
        }
        .padding(.top, 8)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                self.orientation = UIDevice.current.orientation
                updateOrientation()
            }
            updateOrientation()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }
    
    private func updateOrientation() {
        switch orientation {
        case .portrait, .portraitUpsideDown:
            isLandscape = false
            print("Portrait")
        case .landscapeLeft, .landscapeRight:
            isLandscape = true
            print("Landscape")
        default:
            break
        }
    }

}
