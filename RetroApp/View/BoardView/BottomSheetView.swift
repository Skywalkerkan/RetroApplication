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
    @State var cardDescription: String
    @State var cardCreatedTime: String
    @State var cardCreatedBy: String

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                TextEditor(text: $cardContext)
                    .frame(minHeight: 70, alignment: .leading)
                    .frame(maxHeight: 300)
                    .foregroundColor(.black)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .padding(.bottom, -4)
                    .background(Color.white)
                
                HStack {
                    Text("Spring 1")
                        .bold()
                    Text("Listesinde")
                    Text("Went Well Boardu")
                        .bold()
                    Spacer()
                }
                .padding(.bottom, 12)
                .padding(.horizontal, 12)

                Divider()
                
                HStack(spacing: 0) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .frame(width: 45, height: 45, alignment: .center)
                        .foregroundColor(.gray)
                    
                    TextEditor(text: $cardDescription)
                        .padding(.leading, -4)
                        .frame(minHeight: 40, alignment: .leading)
                        .frame(maxHeight: 70)
                        .cornerRadius(10, antialiased: true)
                        .foregroundColor(.black)
                        .font(.body)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
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

