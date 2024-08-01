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
  //  @Binding var cellHeight: CGFloat 

    @State private var dragOffset = CGSize.zero
    @State private var cellPosition: CGPoint = .zero
  //  @State private var cellHeight: CGFloat = 0

    
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
                        .preference(key: SizePreferenceKey.self, value: geometry.size.height)
                        .onChange(of: geometry.size.height) { newSize in
                                print("Card height: \(newSize)")
                              //  self.cellHeight = newSize
                        }
                })
             //   .measureSize(size: $cellHeight)
        }
        .background(Color(red: 0.99, green: 0.99, blue: 0.99))

        .offset(dragOffset)

    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MeasureSizeModifier: ViewModifier {
    @Binding var size: CGFloat

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size.height)
            })
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                DispatchQueue.main.async {
                    self.size = newSize
                    print("Measured height: \(newSize)")
                }
            }
    }
}

extension View {
    func measureSize(size: Binding<CGFloat>) -> some View {
        self.modifier(MeasureSizeModifier(size: size))
    }
}
