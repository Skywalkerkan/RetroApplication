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
    @StateObject var viewModel = BoardViewModel()

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                ScrollViewReader { proxy in
                    HStack(spacing: 16) {
                      /*  DroppableList("List 1", users: $users1, backgroundColor: .green) { dropped, index in
                            if !users1.contains(dropped) {
                                users1.insert(dropped, at: index)
                                users2.removeAll { $0 == dropped }
                                users3.removeAll { $0 == dropped }
                            }
                        }
                        .frame(width: 300)
                        .background(GeometryReader { geometry in
                            Color.clear.onAppear {
                                scrollViewProxy = proxy
                            }
                            .onChange(of: geometry.frame(in: .global).minX) { value in
                                handleScrollIfNeeded(xPosition: value, in: geometry)
                            }
                        })*/
                        
                        
                        ForEach(viewModel.boards.indices, id: \.self) { index in
                            DroppableList("Board \(index+1)", boardIndex: index, cards: $viewModel.boards[index].cards, backgroundColor: .green) { dropped, index, boardActualIndex in
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
                                
                                viewModel.updateBoards(sessionId: "123456", boards: viewModel.boards)
/*
                                for board in viewModel.boards {
                                }*/
                                                  
                            }
                            .frame(width: 300)
                        }


                    }
                    .scrollTargetLayout()
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))

                }
            }.background(.white)
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 8)


        }
        .onAppear {
            viewModel.startSessionExpirationTimer(for: "123456")
            viewModel.fetchBoards(sessionId: "123456")
            print("Started session expiration timer.")
        }
        .alert(isPresented: $showSessionExpiredAlert) {
            return Alert(
                title: Text("Oturum Süresi Doldu"),
                message: Text("Bu oturumun süresi doldu. Lütfen yeni bir oturum oluşturun."),
                dismissButton: .default(Text("Tamam"))
            )
        }
        .onReceive(viewModel.$showSessionExpiredAlert) { showAlert in
            print("Received alert: \(showAlert)")
            showSessionExpiredAlert = showAlert
        }
        .navigationTitle("Board View Title")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func handleScrollIfNeeded(yPosition: CGFloat, in geometry: GeometryProxy) {
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

#Preview {
    BoardView()
}



