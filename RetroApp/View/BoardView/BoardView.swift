//
//  BoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct BoardView: View {
    @State var users1 = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"]
    @State var users2 = ["Pauline", "Bugünkü yapılan şeyleri tasvip etmiyorum kötüydük.", "Adam"]
    @State var users3 = ["Erkan", "Oke", "Dama"]
    
    @State private var scrollViewProxy: ScrollViewProxy? = nil

    var body: some View {
        VStack {
    /*        HStack {
                Spacer()
                Text("Users")
                    .font(.headline)
                Spacer()
                EditButton()
                Spacer()
                    .frame(width: 10)
            }*/
            
            ScrollView(.horizontal) {
                ScrollViewReader { proxy in
                    HStack(spacing: 0) {
                        DroppableList("Users 1", users: $users1, backgroundColor: .green) { dropped, index in
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
                        })

                        DroppableList("Users 2", users: $users2, backgroundColor: .red) { dropped, index in
                            if !users2.contains(dropped) {
                                users2.insert(dropped, at: index)
                                users1.removeAll { $0 == dropped }
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
                        })

                        DroppableList("Users 3", users: $users3, backgroundColor: .cyan) { dropped, index in
                            if !users3.contains(dropped) {
                                users3.insert(dropped, at: index)
                                users1.removeAll { $0 == dropped }
                                users2.removeAll { $0 == dropped }
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
                        })
                    }
                }
            }.background(.white)
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
