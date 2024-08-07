//
//  AnimationView.swift
//  RetroApp
//
//  Created by Erkan on 6.08.2024.
//


import SwiftUI

struct AnimationButtonView: View {
    
    @State private var showButtons = false
    var onJoinPanel: () -> Void

    var body: some View {
            ZStack {
                if showButtons {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                } else {
                    Color.black.opacity(0)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            if showButtons {
                                NavigationLink(destination: CreateBoardView()) {
                                    VStack {
                                        Image(systemName: "note.text.badge.plus")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.cyan)
                                        Text("Panel Oluştur")
                                            .foregroundColor(.white)
                                    }
                                }
                                .offset(y: -70)
                                .transition(.scale)
                            }

                            if showButtons {
                                Button(action: {
                                    onJoinPanel()
                                }) {
                                    VStack {
                                        Image(systemName: "person.3.fill")
                                            .resizable()
                                            .frame(width: 45, height: 35)
                                            .foregroundColor(.cyan)
                                        Text("Panele Katıl")
                                            .foregroundColor(.white)
                                    }
                                }
                                .offset(x: -80)
                                .transition(.scale)
                            }

                            Button(action: {
                                withAnimation {
                                    showButtons.toggle()
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.cyan)
                            }
                        }
                        .padding(16)
                    }
                }
            }.onAppear() {
                showButtons = false
            }
        }
}

/*
struct AnimationButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationButtonView()
    }
}
*/
