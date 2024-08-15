//
//  DraggableCell.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI


struct DraggableCellView: View {
    let card: Card
    var isAnonym: Bool
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if !isAnonym {
                    HStack {
                        Image(systemName: "person.circle")
                        Text(card.userName)
                    }
                    
                    Divider()
                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .frame(height: 0.8)
                        .padding(.top, 2)
                        .padding(.bottom, 4)
                }
                
                Text(card.description)
                    .multilineTextAlignment(.leading)
                    .onDrag { NSItemProvider(object: card.id as NSString) }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.headline)
                    .foregroundColor(.black)

            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.white)
    }
}
