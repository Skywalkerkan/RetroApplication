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
    @State private var navigateToBoardView = false
    
    @ObservedObject var viewModel = CreateBoardViewModel()
    
    var body: some View {
        
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
            
           /* List(viewModel.listItems) { item in
                PanelCell(panelName: item.name)
            }*/
            Spacer()
            
            Button(action: {
                let sessionId = "123456"
                viewModel.createSession(createdBy: "Skaywalker", sessionId: sessionId)
                let board = Board(id: UUID().uuidString, name: "Board 1", cards: [Card(id: UUID().uuidString, name: "card", items: [ListItem(name: "sdfsasd", likes: 5)])])
                viewModel.createBoard(sessionId: sessionId, board: board)
                navigateToBoardView = true
            }) {
                Text("Kaydet")
                    .frame(width: 150, height: 40)
                    .foregroundColor(.white)
                    .background(Color.cyan)
                    .cornerRadius(8)
            }
            .padding(.bottom, 20)
            
            NavigationLink(
                destination: BoardView().navigationBarTitleDisplayMode(.inline),
                isActive: $navigateToBoardView,
                label: { EmptyView() }
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Pano Eklenemedi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
        }
        .navigationTitle("Pano Oluştur")
    }
}

#Preview {
    CreateBoardView()
}
