//
//  BottomSheetView.swift
//  RetroApp
//
//  Created by Erkan on 6.08.2024.
//

import SwiftUI

struct BottomSheetView: View {
    
    @Binding var cardContext: String
    @State var boardName: String
    @State var cardCreatedTime: String
    @State var cardCreatedBy: String
    @Binding var isChangedDescription: Bool

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 4) {
                Text("Kartı düzenle")
                    .font(.title2)
                    .bold()
                    .padding(.leading, 4)
                TextEditor(text: $cardContext)
                    .frame(minHeight: 25, alignment: .leading)
                    .foregroundColor(.black)
                    .font(.body)
                    .background(Color.white)
            }
            .padding(8)
            
        }
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    print("Ekleme yeri")
                    isChangedDescription.toggle()
                }) {
                    Image(systemName: "checkmark")
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                }
                Button(action: {
                    print("Silme Yeri")
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

/*
struct BottomSheetView_Previews: PreviewProvider {
    @State static var descriptionString = "Initial text"
    
    static var previews: some View {
        BottomSheetView(cardContext: "Erkan")
    }
}*/

