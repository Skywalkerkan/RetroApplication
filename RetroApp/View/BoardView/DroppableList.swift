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
    @Binding var cards: [Card]
    @State private var draggingCardIndex: Int?
    @State private var boardInfoClicked: Bool = false
    @State private var isMoveActive: Bool = false
    @StateObject var viewModel = BoardViewModel()

    let isAnonym: Bool
    let action: ((Card, Int, Int) -> Void)?
    let sessionId: String
    @State private var cellHeight: CGFloat = 0
    @State var cellHeights = [CGFloat]()

    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero
    @State private var showingBottomSheet: Bool = false

    
    init(_ title: String, boardIndex: Int, cards: Binding<[Card]>, sessionId: String, isAnonym: Bool, action: ((Card, Int, Int) -> Void)? = nil) {
        self.title = title
        self.boardIndex = boardIndex
        self._cards = cards
        self.sessionId = sessionId
        self.isAnonym = isAnonym
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
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
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
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                    }
                    .background(Color(red: 241/255, green: 242/255, blue: 244/255))
                    .zIndex(6)

                    List {
                        if cards.isEmpty {
                            EmptyPlaceholder()
                                .onDrop(of: [.data], isTargeted: nil, perform: dropOnEmptyList)
                                .listRowBackground(Color.cyan)
                                .frame(height: 300)
                        } else {
                            ForEach(cards, id: \.self) { card in
                                DraggableCellView(card: card, isAnonym: isAnonym)

                                    .listRowInsets(EdgeInsets(top: 0.5, leading: 0.5, bottom: 0.5, trailing: 0.5))
                                    .listRowBackground(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 0.98, green: 0.98, blue: 0.98), lineWidth: 1)
                                    )

                                    .onTapGesture {
                                        print("Basıldı \(boardIndex) \(card)")
                                        showingBottomSheet = true
                                    }
                                    .onPreferenceChange(SizePreferenceKey.self) { newSize in
                                           DispatchQueue.main.async {
                                                   print("cardlarım \(boardIndex) \(cards)")
                                                   print("Card height: \(newSize) \(boardIndex)")
                                                   self.cellHeight = newSize
                                                   cellHeights.append(newSize) // Burada hata yok
                                                   print("Sayı \(cellHeights.count)")
                                           }
                                       }
                            }

                            .onMove(perform: moveCard)
                            .onInsert(of: ["public.text"], perform: dropCard)
                        }
                    }
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)

                    .zIndex(2)
                    .listRowSpacing(8)
                   // .frame(maxHeight: min(geometry.size.height - 70, calculateHeight(cellHeights: cellHeights) /* CGFloat(cards.count * 70 + 50)*/))
                    .padding(.top, -20)

                     HStack {
                         Button {
                             print("Basıldı \(boardIndex)")
                             let newCard = Card(id: UUID().uuidString, description: "asdfsadfasdfsdkfjsdakfjasdkfhasdkjfhaskjdfhaksdfjasdk", userName: "Erkan 1")
                             viewModel.addCardToBoard(sessionId: sessionId, boardIndex: boardIndex, newCard: newCard)
                            
                         } label: {
                             Text("+ Kart Ekle")
                                 .foregroundColor(.black)
                         }
                     }
                     .zIndex(10)
                     .frame(height: 40)
                     .padding(.horizontal, 8)
                }
                .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                .cornerRadius(20)
                .scrollContentBackground(.hidden)
                
                if boardInfoClicked {
                    List {
                        Text("Erkan")
                        Text("Erkan")
                        Text("Erkan")
                    }
                    .frame(width: 250, height: 130)
                    .scrollContentBackground(.hidden)
                    .cornerRadius(8)
                    .background(Color.red)
                    .listStyle(.plain)
                    .padding(EdgeInsets(top: 40, leading: 25, bottom: 0, trailing: 25))
                    .scrollDisabled(true)
                   
                }
            }
            .sheet(isPresented: $showingBottomSheet) {
                BottomSheetView(descriptionString: "Erkancık")
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }

    }
    
    func calculateHeight(cellHeights: [CGFloat]) -> CGFloat {
        var cellHeight: CGFloat = 0
        for cell in cellHeights {
            cellHeight += cell
            cellHeight += 26
        }
        return cellHeight + 50
    }

    struct EmptyPlaceholder: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.cyan)
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
    
    func moveCard(from source: IndexSet, to destination: Int) {
        isMoveActive = true
        cards.move(fromOffsets: source, toOffset: destination)
        print("moving car\(cards)")
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

