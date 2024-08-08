//
//  BottomSheetView.swift
//  RetroApp
//
//  Created by Erkan on 6.08.2024.
//

import SwiftUI

struct BottomSheetView: View {
    
    @State var cardContext: String
    @State var boardName: String
    @State var cardCreatedTime: String
    @State var cardCreatedBy: String
    @Binding var isChangedDescription: Bool

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 4) {
                TextEditor(text: $cardContext)
                    .frame(minHeight: 30, alignment: .leading)
                    .frame(maxHeight: 200)
                    .foregroundColor(.black)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    .background(Color.white)

                Divider()
                
                HStack(spacing: 0) {
                    Image(systemName: "clock")
                        .frame(width: 50, height: 50, alignment: .leading)
                        .padding(.leading, 12)
                        .foregroundColor(.gray)
                    Text("\(cardCreatedTime)")

                    Spacer()
                }
                Divider()
                
                HStack(spacing: 0) {
                    Image(systemName: "person")
                        .frame(width: 50, height: 50, alignment: .leading)
                        .padding(.leading, 12)
                        .foregroundColor(.gray)
                    
                    Text("\(cardCreatedBy)")
                    Spacer()
                }

                Divider()
                Spacer()
                
            }
            
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

