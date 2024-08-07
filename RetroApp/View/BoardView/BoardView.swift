//
//  BoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct BoardView: View {

    @State private var showSessionExpiredAlert = false
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isAddBoarding: Bool = false
    @State private var addBoardTextField: String = ""
    @StateObject var viewModel = BoardViewModel()
    @FocusState private var isTextFieldFocused: Bool
    var sessionId: String
    
    init(sessionId: String) {
        self.sessionId = sessionId
    }
 
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                ScrollViewReader { proxy in
                    HStack(spacing: 4) {
                        
                        ForEach(viewModel.boards.indices, id: \.self) { index in
                            DroppableList(viewModel.boards[index].name, boardIndex: index, cards: $viewModel.boards[index].cards, sessionId: self.sessionId, isAnonym: viewModel.session?.isAnonym ?? false) { dropped, index, boardActualIndex in
                                print(dropped.id ,index, boardActualIndex)
                                
                                var boardIndex = 0
                                var cardIndex = 0
                                var cardIndex2 = 0
                                var boardIndex2 = 0
                                var found = false
                                
                                var cardActual: Card?
                                for board in viewModel.boards {
                                    for card in board.cards {
                                        if card.id == dropped.id {
                                            cardActual = Card(id: card.id, description: card.description, userName: card.userName)
                                            found = true
                                            break
                                        }
                                        cardIndex += 1
                                    }
                                    if found { break }
                                    cardIndex = 0
                                    boardIndex += 1
                                }
                                
                                for board in viewModel.boards {
                                    for card in board.cards {
                                        if card.id == dropped.id {
                                            print("cardid \(card.id)")
                                            break
                                        }
                                        print(card.id)
                                    }
                                    boardIndex2 += 1
                                }
                                
                                viewModel.boards = viewModel.boards.map { board in
                                    var updatedBoard = board
                                    print()
                                    updatedBoard.cards.removeAll { $0.id == dropped.id }
                                    return updatedBoard
                                }
                                
                                viewModel.boards[boardActualIndex].cards.insert(cardActual ?? Card(id: "12345", description: "12345", userName: "Erkan1"), at: index)
                                
                                viewModel.updateBoards(sessionId: sessionId, boards: viewModel.boards)
                                
                            }
                            .padding(.top, -4)
                            .frame(width: 300)
                        }
                        
                        VStack {
                            if !isAddBoarding {
                                
                                Button {
                                    isAddBoarding.toggle()
                                    isTextFieldFocused.toggle()
                                } label: {
                                    Text("Board Oluştur")
                                        .frame(width: 300, height: 50)
                                }
                                .background(Color.black)
                                .cornerRadius(8)
                                Spacer()
                            } else {
                                TextField("Liste Adı", text: $addBoardTextField)
                                    .frame(width: 270)
                                    .padding()
                                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                    .focused($isTextFieldFocused)

                                Spacer()

                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))

                }
            }.background(Color(red: 81/255, green: 94/255, blue: 132/255))
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 8)


        }
        .onAppear {
            viewModel.startSessionExpirationTimer(for: sessionId)
            viewModel.fetchBoards(sessionId: sessionId)
            print("Started session expiration timer.")
        }
       /* .alert(isPresented: $showSessionExpiredAlert) {
            return Alert(
                title: Text("Oturum Süresi Doldu"),
                message: Text("Bu oturumun süresi doldu. Lütfen yeni bir oturum oluşturun."),
                dismissButton: .default(Text("Tamam"))
            )
        }*/
        .onReceive(viewModel.$showSessionExpiredAlert) { showAlert in
            print("Received alert: \(showAlert)")
            showSessionExpiredAlert = showAlert
        }
        .navigationTitle(viewModel.session?.sessionName ?? "")
        .navigationBarBackButtonHidden(isAddBoarding)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isAddBoarding {
                    Button(action: {
                        viewModel.createBoard(sessionId: sessionId, board: Board(id: UUID().uuidString, name: addBoardTextField, cards: []))
                        isAddBoarding.toggle()
                        addBoardTextField = ""
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if isAddBoarding {
                    Button(action: {
                        isAddBoarding.toggle()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if isAddBoarding {
                    Text("Listeye ekle")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func handleScrollIfNeeded(yPosition: CGFloat, in geometry: GeometryProxy) {
        print(UIScreen.main.bounds.width)

        guard let proxy = scrollViewProxy else { return }
        let screenHeight = UIScreen.main.bounds.height
        let scrollThreshold: CGFloat = 30
        let scrollAmount: CGFloat = 20
        if yPosition < scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(yPosition - scrollAmount, anchor: .top)
            }
        } else if yPosition > screenHeight - scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(yPosition + scrollAmount, anchor: .bottom)
            }
        }
    }

    func handleScrollIfNeeded(xPosition: CGFloat, in geometry: GeometryProxy) {
        print(UIScreen.main.bounds.width)

        guard let proxy = scrollViewProxy else { return }
        let screenWidth = UIScreen.main.bounds.width
        let scrollThreshold: CGFloat = 30
        let scrollAmount: CGFloat = 20
        print(scrollThreshold)
        if xPosition < scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(xPosition - scrollAmount, anchor: .leading)
            }
        } else if xPosition > screenWidth - scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(xPosition + scrollAmount, anchor: .trailing)
            }
        }
    }
}

/*
#Preview {
    BoardView()
}*/



