//
//  DroppableList.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct DroppableList: View {
    let title: String
    let boardIndex: Int
    let isAnonym: Bool
    let action: ((Card, Int, Int) -> Void)?
    let sessionId: String
    let currentUserName: String
    @State var chosenCard: Card?
    @Binding var cards: [Card]
    @State private var draggingCardIndex: Int?
    @State private var boardInfoClicked: Bool = false
    @State private var isMoveActive: Bool = false
    @StateObject var viewModel = BoardViewModel()
    @State private var cellHeight: CGFloat = 0
    @State var cellHeights = [CGFloat]()
    @State private var cardId: String = ""
    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero
    @State private var showingBottomSheet: Bool = false
    @State private var addingCardClicked: Bool = false
    @State private var scrolltoTop: Bool = false
    @State private var newCardDescription: String = ""
    @State private var isAddCardViewVisible: Bool = false
    @State private var isChangedDescription: Bool = false
    @State var cardContext: String = ""
    
    init(_ title: String, boardIndex: Int, cards: Binding<[Card]>, sessionId: String, isAnonym: Bool, currentUserName: String, action: ((Card, Int, Int) -> Void)? = nil) {
        self.title = title
        self.boardIndex = boardIndex
        self._cards = cards
        self.sessionId = sessionId
        self.isAnonym = isAnonym
        self.currentUserName = currentUserName
        self.action = action
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 0) {
                    HStack(alignment: .top) {
                        Text(title)
                            .font(.headline)
                            .lineLimit(2)
                            .padding(.top, 10)
                            .padding(.bottom, 8)
                        
                        Spacer()
                        
                        Menu {
                            Button("Rename yap") {
                                
                            }
                            
                            Button("Delete", role: .destructive) {
                                viewModel.deleteBoard(sessionId: sessionId, boardIndex: boardIndex)
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis.circle").renderingMode(.original).tint(.black)
                                .imageScale(.large)
                                .frame(width: 25, height: 25)
                                .padding(.vertical, 8)
                                .padding(.bottom, 8)

                        }
                    }
                    .frame(width: 270, height: 40)
                    .cornerRadius(4)
                    .zIndex(6)
                    
                    Button(action: {
                        print("Artı Basıldı \(isAddCardViewVisible)")
                        scrolltoTop.toggle()
                        isAddCardViewVisible.toggle()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .frame(width: 268, height: 30)
                            .cornerRadius(2)
                    }
                    .background(Color(red: 229/255, green: 229/255, blue: 234/255))
                    .zIndex(7)
                    
                    if isAddCardViewVisible {
                        AddCardView(cardDescription: "Type Something...") { description in
                            print(currentUserName)
                            let newCard = Card(id: UUID().uuidString, description: description, userName: currentUserName)
                            viewModel.addCardToBoard(sessionId: sessionId, boardIndex: boardIndex, newCard: newCard)
                            cards.append(newCard)
                            scrolltoTop.toggle()
                            isAddCardViewVisible.toggle()
                        } onCloseCard: {
                            print("xmark button pressed")
                            isAddCardViewVisible.toggle()
                        }
                    }
                    
                    ScrollViewReader { proxy in
                        List {
                            if cards.isEmpty {
                                EmptyPlaceholder()
                                    .onDrop(of: [.data], isTargeted: nil, perform: dropOnEmptyList)
                                    .listRowBackground(Color.clear)
                                    .frame(height: 300)
                            } else {
                                ForEach(cards, id: \.self) { card in
                                    DraggableCellView(card: card, isAnonym: isAnonym)
                                        .listRowInsets(EdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5))
                                        .listRowBackground(Color(red: 81/255, green: 94/255, blue: 132/255))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(red: 0.98, green: 0.98, blue: 0.98), lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            print("Basıldı \(boardIndex) \(card)")

                                            cardId = card.id
                                            
                                            chosenCard = card
                                            cardContext = card.description
                                            showingBottomSheet = true
                                        }
                                }
                                .onMove(perform: moveCard)
                                .onInsert(of: ["public.text"], perform: dropCard)
                            }
                        }
                        .onChange(of: scrolltoTop) { _ in
                            DispatchQueue.main.async {
                                   if let lastCard = cards.first {
                                       print("gidiliyor")
                                       withAnimation {
                                           proxy.scrollTo(lastCard.id, anchor: .bottom)
                                       }
                                   }
                               }  
                        }
                        .contentMargins(.vertical, 10)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                        .zIndex(2)
                        .listRowSpacing(8)
                    }
                }
                .background(Color.clear)
                .cornerRadius(20)
                .scrollContentBackground(.hidden)
            }
            .sheet(isPresented: $showingBottomSheet) {
                BottomSheetView(cardContext: $cardContext,
                                boardName: title,
                                cardCreatedTime: chosenCard?.createdAt?.toString() ?? "Unknown Date" ,
                                cardCreatedBy: chosenCard?.userName ?? "Anonymous",
                                isChangedDescription: $isChangedDescription)
                
                .onChange(of: isChangedDescription) { newValue in
                    viewModel.updateCardName(sessionId: sessionId, boardIndex: boardIndex, cardId: cardId, newCardDescription: cardContext)
                    showingBottomSheet = false
                }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    struct EmptyPlaceholder: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
    
    func moveCard(from source: IndexSet, to destination: Int) {
        isMoveActive = true
        cards.move(fromOffsets: source, toOffset: destination)
        print("\(cards)")
        viewModel.reorderCardInSession(sessionId: sessionId, boardIndex: boardIndex, cards: cards)
    }
    
    func dropCard(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            item.loadObject(ofClass: String.self) { droppedString, _ in
                if let ss = droppedString {
                    DispatchQueue.main.async {
                        if let dropAction = action {
                            let droppedCard = Card(id: ss, description: ss, userName: ss)
                            print("Dropped card '\(ss)' at index \(index) from board \(boardIndex)")
                            dropAction(droppedCard, index, boardIndex)
                        }
                    }
                }
            }
        }
    }
    
    func dropOnEmptyList(items: [NSItemProvider]) -> Bool {
        dropCard(at: cards.endIndex, items)
        return true
    }
}

