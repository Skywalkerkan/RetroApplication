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
    @State private var selectedUser: String? = nil
    @State private var expandedUser: String? = nil
    
    let backgroundColor: Color
    let action: ((Card, Int, Int) -> Void)?
    
    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero
    
    init(_ title: String, boardIndex: Int, cards: Binding<[Card]>, backgroundColor: Color, action: ((Card, Int, Int) -> Void)? = nil) {
        self.title = title
        self.boardIndex = boardIndex
        self._cards = cards
        self.backgroundColor = backgroundColor
        self.action = action
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                List {
                    if cards.isEmpty {
                        EmptyPlaceholder()
                            .onDrop(of: [.data], isTargeted: nil, perform: dropOnEmptyList)
                            .listRowBackground(Color.cyan)
                            .frame(height: 300)
                    } else {
                        ForEach(cards, id: \.self) { card in
                            DraggableCellView(card: card, selectedUser: $selectedUser, expandedUser: $expandedUser)
                        }
                        .onMove(perform: moveCard)
                        .onInsert(of: ["public.text"], perform: dropCard)
                    }
                }
                
                HStack {
                    Button {
                        print("Basıldı")
                    } label: {
                        Text("+ Kart Ekle")
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 20)
        .background(Color(red: 0.93, green: 0.93, blue: 0.93))
        .cornerRadius(8)
    }
    
    struct EmptyPlaceholder: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.cyan)
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
    
    func moveCard(from source: IndexSet, to destination: Int) {
        cards.move(fromOffsets: source, toOffset: destination)
        print("moving car\(cards)")
    }
    
    func dropCard(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            item.loadObject(ofClass: String.self) { droppedString, _ in
                if let ss = droppedString {
                    DispatchQueue.main.async {
                        if let dropAction = action {
                            let droppedCard = Card(id: ss, name: ss)
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
