//
//  DraggableCell.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI


struct DraggableCellView: View {
    let card: Card
    @Binding var selectedUser: String?
    @Binding var expandedUser: String?
    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.description)
                .multilineTextAlignment(.leading)
                .onDrag { NSItemProvider(object: card.id as! NSString) }
                .padding(.top, 0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .background(GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.frame(in: .global).origin) { newPosition in
                            cellPosition = newPosition
                        }
                })

            HStack {
                Spacer()
                
                Button(action: {
                    selectedUser = selectedUser == card.description ? nil : card.description
                    expandedUser = expandedUser == card.description ? nil : card.description
                }) {
                    Image(systemName: expandedUser == card.description ? "bubble.fill" : "bubble")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, -2)

                Text("5")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.trailing, -8)
            .padding(.top, 4)

            if expandedUser == card.description {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<5) { _ in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .padding(.leading, 8)
                                    .foregroundColor(.black)
                                Text("Anonymous")
                                    .fontWeight(.black)
                                    .font(.subheadline)
                            }

                            Text("Bu bir yorumdurasasdfa sdfadsfasfdfadsfasdfads")
                                .padding(.leading, 4)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                        .padding(8)
                        .background(Color.gray)
                        .cornerRadius(8)
                    }
                    .padding(.bottom, 8)
                }
            }
        }
      //  .padding(.leading, 4)
      //  .padding(.trailing, 4)
        .offset(dragOffset)
        /*.gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                    print("Drag offset: \(dragOffset)")
                }
                .onEnded { _ in
                    dragOffset = .zero
                }
        )*/
    }
}

/*
#Preview {
    DraggableCell()
}*/
