//
//  AnimationView.swift
//  RetroApp
//
//  Created by Erkan on 6.08.2024.
//

import SwiftUI

struct AnimationButtonView: View {
    
    @State private var showButtons = false
    @State private var showCreateView = false
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
                            Button(action: {
                                showCreateView = true
                            }) {
                                VStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "note.text.badge.plus")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.cyan)
                                                .padding(.leading, 6)
                                                .padding(.top, 2)
                                        )
                                    
                                    Text("Panel Oluştur")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                }
                            }
                            .offset(y: -70)
                            .transition(.scale)
                            .fullScreenCover(isPresented: $showCreateView) {
                                CreateBoardView(showCreateView: $showCreateView)
                            }
                        }

                        if showButtons {
                            Button(action: {
                                onJoinPanel()
                            }) {
                                VStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "person.3.fill")
                                                .resizable()
                                                .frame(width: 25, height: 20)
                                                .foregroundColor(.cyan)
                                                .padding(.leading, 2)
                                        )
                                    
                                    Text("Panele Katıl")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                                }
                            }
                            .offset(x: -70)
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
        }
        .onChange(of: showCreateView) { newValue in
            if !showCreateView {
                showButtons = false
            }
        }
        .onAppear() {
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
