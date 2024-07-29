//
//  ContentView.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var showRectangle = false
    @State private var sessionId: String = ""
    @State private var isSecure = true
    @State private var isLoading = false


    var body: some View {
        NavigationView {
            ZStack {
               /* if viewModel.items.isEmpty {
                    VStack {
                        Spacer()
                        Text("No Items")
                            .font(.title)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List(viewModel.items) { item in
                        PanelCell(panelName: item.title)
                    }
                }*/
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CreateBoardView()) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.cyan)
                                .clipShape(Circle())
                        }
                        .padding(16)
                    }
                }
                
                if showRectangle {
                    ZStack {
                        Color.black
                            .opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showRectangle = false
                                }
                            }

                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.width*0.8, alignment: .center)
                            .edgesIgnoringSafeArea(.top)
                            .cornerRadius(10)
                            .scaleEffect(showRectangle ? 1 : 0.5)
                            .animation(.easeInOut(duration: 0.3), value: showRectangle)
                            .foregroundColor(Color.white)
                            .overlay(
                                
                                VStack(alignment: .center) {
                                    Spacer()
                                    Text("Please Enter A Session Id")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                    HStack {
                                         if isSecure {
                                             SecureField("Session Id", text: $sessionId)
                                                 .padding()
                                                 .background(Color.gray.opacity(0.2))
                                                 .cornerRadius(8)
                                         } else {
                                             TextField("Session Id", text: $sessionId)
                                                 .padding()
                                                 .background(Color.gray.opacity(0.2))
                                                 .cornerRadius(8)
                                         }
                                         
                                         Button(action: {
                                             isSecure.toggle()
                                         }) {
                                             Image(systemName: isSecure ? "eye.slash" : "eye")
                                                 .foregroundColor(.gray)
                                         }
                                         .padding(.trailing, 10)
                                     }
                                    .padding(.leading, 24)
                                    .padding(.trailing, 8)
                                    Spacer()
                                    Button {
                                        isLoading = true//Boş hatayı düzelt
                                        viewModel.joinSession(sessionId)
                                        if viewModel.isItValidId {
                                            print("ok")
                                            isLoading = false
                                        } else {
                                            print("ononk")
                                            isLoading = false
                                        }
                                    } label: {
                                        Text("Devam Et")
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: 120, height: 45, alignment: .center)
                                    .background(Color.cyan)
                                    .cornerRadius(4)
                                    Spacer()

                                }
                            )
                    }
                    .zIndex(1)
                }
                
            }
            .navigationTitle("My List")
            .navigationBarItems(
                leading: Button(action: {
                    print("line")
                }) {
                    Image(systemName: "line.3.horizontal")
                },
                trailing: HStack {
                    Button(action: {
                        print("Bildiri")
                    }) {
                        Image(systemName: "bell")
                    }
                    Button(action: {
                        print("Settings")
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showRectangle = true
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
            .onAppear {
                print("girdim")
                // viewModel.fetchItems()
                // viewModel.addItem(RetroItem(title: "Sprint1", description: "Description", category: .toDo))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
