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
                        .background(Color.gray)
                        .frame(height: 1)
                        .padding(.top, 8)
                }
                
                Text(card.description)
                    .multilineTextAlignment(.leading)
                    .onDrag { NSItemProvider(object: card.id as NSString) }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: geometry.size.height)
                            .onChange(of: geometry.size.height) { newSize in
                                print("Card height: \(newSize)")
                            }
                    })

            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.white)
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


#Preview {
    DraggableCellView(card: Card(id: "123321525", description: "asdadsfas", userName: "Erkan"), isAnonym: true)
}
