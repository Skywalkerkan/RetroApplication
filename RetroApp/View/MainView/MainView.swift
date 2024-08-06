//
//  ContentView.swift
//  RetroApp
//
//  Created by Erkan on 24.07.2024.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var showSessionFinder = false
    @State private var sessionId: String = ""
    @State private var userName: String = ""
    @State private var isSecure = true
    @State private var isLoading = false
    @State private var isValidId = false
    @State private var navigateToBoardView = false
    @State private var showButtons = false

    @State private var chosenSession: String = ""
    
    @State private var navigationPath = NavigationPath()

    @Query private var items: [SessionPanel]
    @Environment(\.modelContext) var context

    
    var horizontalItems = ["1","2","3","4"]
    var verticalItems = ["Item A", "Item B", "Item C", "Item D"]
    
    var body: some View {
        NavigationStack() {
             ZStack {

                 List {

                     if !horizontalItems.isEmpty {
                         Section(header: Text("Yıldızlı Panolar")) {
                             ScrollView(.horizontal, showsIndicators: false) {
                                 HStack(spacing: 16) {
                                     ForEach(horizontalItems, id: \.self) { item in
                                         VStack {
                                             Rectangle()
                                                 .frame(width: 150, height: 100)
                                                 .cornerRadius(4)
                                                 .foregroundColor(.cyan)
                                             Text(item)
                                                 .foregroundColor(.black)
                                                 .cornerRadius(10)
                                         }
                                         .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))

                                     }
                                 }
                             }
                             .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                         }
                     }

                     Section(header: Text("Son Kullanılan Panolar")) {
                         ForEach(items, id: \.self) { item in
                             HStack {
                                 
                                 Rectangle()
                                     .frame(width: 60, height: 40)
                                     .foregroundColor(.green)
                                     .cornerRadius(2)
                                 Text(item.sessionName)
                                     .padding()
                                     .foregroundColor(.black)
                                     .cornerRadius(10)
                                 Button(action: {
                                     chosenSession = item.sessionId
                                     viewModel.joinSession(chosenSession) { isValid in
                                         isLoading = false
                                         isValidId = isValid
                                         if isValid {
                                             print("Valid session ID")
                                             navigateToBoardView = true
                                         } else {
                                             print("Invalid session ID")
                                         }
                                     }
                                 }) {

                                 }
                                 .background(
                                     NavigationLink(destination: BoardView(sessionId: item.sessionId), isActive: $navigateToBoardView) {
                                         EmptyView()
                                     }
                                 )
                             }
                         }
                         .onDelete { indexes in
                             for index in indexes {
                                 deleteItem(items[index])
                             }
                         }

                     }
                 }
                 .listStyle(GroupedListStyle())
                 
                 AnimationButtonView(onJoinPanel: {
                     showSessionFinder = true
                 })
                 
                 if showSessionFinder {
                     Color.black
                         .opacity(0.5)
                         .ignoresSafeArea()
                         .onTapGesture {
                             withAnimation {
                                 showSessionFinder = false
                             }
                         }
                     
                     GeometryReader { geometry in
                         VStack {
                             Text("Session Id")
                                 .font(.headline)
                                 .foregroundColor(.black)
                                 .multilineTextAlignment(.center)
                                 .padding()

                             HStack {
                                 if isSecure {
                                     SecureField("Session Id", text: $sessionId)
                                         .padding()
                                         .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                                         .cornerRadius(8)
                                 } else {
                                     TextField("Session Id", text: $sessionId)
                                         .padding()
                                         .background(Color.white)
                                         .cornerRadius(8)
                                 }
                                 
                                 Button(action: {
                                     isSecure.toggle()
                                 }) {
                                     Image(systemName: isSecure ? "eye.slash" : "eye")
                                         .foregroundColor(.gray)
                                 }
                                 .padding(.leading, 8)
                             }
                             .padding([.leading, .trailing], 24)
                             
                             Text("NickName")
                                 .font(.headline)
                                 .foregroundColor(.black)
                                 .multilineTextAlignment(.center)
                                 .padding()
                             
                             HStack {
                                 if isSecure {
                                     SecureField("NickName", text: $userName)
                                         .padding()
                                         .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                                         .cornerRadius(8)
                                 } else {
                                     TextField("Nickname", text: $userName)
                                         .padding()
                                         .background(Color.white)
                                         .cornerRadius(8)
                                 }
                                 
                                 Button(action: {
                                     isSecure.toggle()
                                 }) {
                                     Image(systemName: isSecure ? "eye.slash" : "eye")
                                         .foregroundColor(.gray)
                                 }
                                 .padding(.leading, 8)
                             }
                             .padding([.leading, .trailing], 24)

                             
                             NavigationLink(destination: BoardView(sessionId: self.sessionId), isActive: $isValidId) {
                                 Button(action: {
                                     isLoading = true
                                     viewModel.joinSession(sessionId) { isValid in
                                         isLoading = false
                                         isValidId = isValid
                                         if isValid {
                                             print("Valid session ID")
                                         } else {
                                             print("Invalid session ID")
                                         }
                                     }
                                 }) {
                                     if isLoading {
                                         ProgressView()
                                             .progressViewStyle(CircularProgressViewStyle())
                                             .frame(width: 120, height: 45)
                                     } else {
                                         Text("Oturum Ara")
                                             .foregroundColor(.white)
                                             .frame(width: 120, height: 45)
                                             .background(Color.cyan)
                                             .cornerRadius(4)
                                     }
                                 }
                             }
                             .padding(.top, 16)
                             
                         }
                         .frame(width: 300, height: 300)
                         .background(.white)
                         .cornerRadius(10)
                         .position(x: geometry.size.width / 2, y: (geometry.size.height - geometry.safeAreaInsets.top) / 2)
                         .transition(.scale)
                     }
                 }

             }
             .navigationBarTitle("My List", displayMode: .inline)
         }
        
    }
    func deleteItem(_ item: SessionPanel) {
        context.delete(item)
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
