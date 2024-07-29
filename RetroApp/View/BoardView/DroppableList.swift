//
//  DroppableList.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct DroppableList: View {
    let title: String
    @Binding var users: [String]
    @State private var selectedUser: String? = nil// Kullancıı
    let userComments: [String: [String]] = [
        "User1": ["Yorum 1", "Yorum 2", "Yorum 3"],
        "User2": ["Yorum A", "Yorum B", "Yorum C"],
        "User3": ["Yorum X", "Yorum Y", "Yorum Z"]
    ]
    @State private var expandedUser: String? = nil // Yorum genişletmesi

    let backgroundColor: Color
    let action: ((String, Int) -> Void)?
    
    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero

    init(_ title: String, users: Binding<[String]>, backgroundColor: Color, action: ((String, Int) -> Void)? = nil) {
        self.title = title
        self._users = users
        self.backgroundColor = backgroundColor
        self.action = action
    }
    var body: some View {
        ZStack {
            List {
                Section(header: Text(title)
                            .font(.callout)
                            .fontWeight(.bold)
                            .onDrop(of: [.plainText], isTargeted: nil, perform: dropOnEmptyList)
                            .foregroundColor(backgroundColor)
                            .onAppear {
                                print("Title view appeared with empty users")
                            }) {
                    if users.isEmpty {
                        EmptyPlaceholder()
                            .onDrop(of: [.data], isTargeted: nil, perform: dropOnEmptyList)
                            .listRowBackground(Color.cyan)
                            .frame(height: 300)
                    } else {
                        ForEach(users, id: \.self) { user in
                            DraggableCellView(user: user, selectedUser: $selectedUser, expandedUser: $expandedUser)
                        }
                        .onMove(perform: moveUser)
                        .onInsert(of: ["public.text"], perform: dropUser)
                    }
                }
            }
        }
    }



    // Boş durumda görünen View
    struct EmptyPlaceholder: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.cyan)
                .frame(maxWidth: .infinity, maxHeight: 200)
                //.foregroundColor(.red)
               /* .overlay(
                    Text("No users available")
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(Color.red)
                )
                .padding()*/
                
        }
        
    }




    func moveUser(from source: IndexSet, to destination: Int) {
        
        for index in source {
            print("Moving item from index \(index) to \(destination)")
        }
        
        users.move(fromOffsets: source, toOffset: destination)
    }

    func dropUser(at index: Int, _ items: [NSItemProvider]) {
        for item in items {
            item.loadObject(ofClass: String.self) { droppedString, _ in
                if let ss = droppedString {
                    DispatchQueue.main.async {
                        if let dropAction = action {
                            print("Dropped item '\(ss)' at index \(index)")
                            dropAction(ss, index)
                        }
                    }
                }
            }
        }
    }
    
    func dropOnEmptyList(items: [NSItemProvider]) -> Bool {
        dropUser(at: users.endIndex, items)
        return true
    }
}

/*
#Preview {
    DroppableList()
}*/
