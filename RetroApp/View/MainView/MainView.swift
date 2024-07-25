//
//  ContentView.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI
import CoreData

struct MainView: View {
    let items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List(items, id: \.self) { item in
                    PanelCell(panelName: item)
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
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
