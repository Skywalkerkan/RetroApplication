//
//  CreateBoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI


struct CreateBoardView: View {
    @State private var textFieldText: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Pano İsmi")
                .font(.title)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Enter board name", text: $textFieldText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, -4)
                        
            HStack {
                Text("Pano Arkaplanı")
                Spacer()
                Rectangle()
                    .cornerRadius(4)
                    .frame(width: 30, height: 30)
            }
            .frame(width: .infinity, height: 50)
            Spacer()
        }
        .padding()
    }}

#Preview {
    CreateBoardView()
}
