//
//  CreateBoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct CreateBoardView: View {
    @State private var textFieldText: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    @ObservedObject var viewModel = CreateBoardViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
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
                    .frame(maxWidth: .infinity, maxHeight: 40)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                Button(action: {
                    let item = RetroItem(title: textFieldText, description: "description", category: .done)
                    viewModel.addItem(item)
                    
                    if let errorMessage = viewModel.errorMessage {
                        alertMessage = errorMessage
                        showAlert = true
                    }
                }) {
                    Text("Kaydet")
                        .frame(width: 150, height: 40)
                        .foregroundColor(.white)
                        .background(Color.cyan)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Pano Eklenemedi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
        .navigationTitle("Pano Oluştur")
    }
}

#Preview {
    CreateBoardView()
}
