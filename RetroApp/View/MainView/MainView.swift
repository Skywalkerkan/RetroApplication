//
//  ContentView.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
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
                    }) {
                        Image(systemName: "gear")
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
