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
  //  @State private var selectedUser: String? = nil
   // @State private var expandedUser: String? = nil
    @State private var draggingCardIndex: Int?
    @State private var boardInfoClicked: Bool = false
    private let infoItems = ["1", "2", "3"] // Example data
    @State private var isMoveActive: Bool = false
    @StateObject var viewModel = BoardViewModel()

    let backgroundColor: Color
    let isAnonym: Bool
    let action: ((Card, Int, Int) -> Void)?
    
    @State private var cellHeight: CGFloat = 0
    @State var cellHeights = [CGFloat]()

    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero
    
    init(_ title: String, boardIndex: Int, cards: Binding<[Card]>, backgroundColor: Color,isAnonym: Bool, action: ((Card, Int, Int) -> Void)? = nil) {
        self.title = title
        self.boardIndex = boardIndex
        self._cards = cards
        self.isAnonym = isAnonym
        self.backgroundColor = backgroundColor
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
                        
                        Spacer()
                        
                        Menu {
                            Button("Rename yap") {
                                
                            }
                            
                            Button("Delete", role: .destructive) {
                                viewModel.deleteBoard(sessionId: "123456", boardIndex: boardIndex)
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis.circle").renderingMode(.original).tint(.black)
                                .imageScale(.large)
                                .frame(width: 25, height: 25)
                        }
                    }
                    .background(Color.indigo)
                    .zIndex(6)
                    .padding(.top, 12)
                    .padding(.horizontal)

                    List {
                        if cards.isEmpty {
                            EmptyPlaceholder()
                                .onDrop(of: [.data], isTargeted: nil, perform: dropOnEmptyList)
                                .listRowBackground(Color.cyan)
                                .frame(height: 300)
                        } else {
                            ForEach(cards, id: \.self) { card in
                                DraggableCellView(card: card, isAnonym: isAnonym)
                                    
                                    .padding(.horizontal, 8)
                                    .onTapGesture {
                                        print("Basıldı \(boardIndex) \(card)")
                                    
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
                    .zIndex(2)
                    .listRowSpacing(4)
                   // .frame(maxHeight: min(geometry.size.height - 70, calculateHeight(cellHeights: cellHeights) /* CGFloat(cards.count * 70 + 50)*/))
                    .padding(.top, -20)

                     HStack {
                         Button {
                             print("Basıldı \(boardIndex)")
                             let newCard = Card(id: UUID().uuidString, description: "asdfsadfasdfsdkfjsdakfjasdkfhasdkjfhaskjdfhaksdfjasdk", userName: "Erkan 1")
                             viewModel.addCardToBoard(sessionId: "123456", boardIndex: boardIndex, newCard: newCard)
                             
                         } label: {
                             Text("+ Kart Ekle")
                                 .foregroundColor(.black)
                         }
                    }
                     .padding(.horizontal, 8)
                }
                .background(Color.indigo)
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
