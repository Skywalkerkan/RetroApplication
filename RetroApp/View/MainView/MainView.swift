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
    @State private var sessionPassword: String = "123456"
    @State private var userName: String = ""
    @State private var isSecure = true
    @State private var isLoading = false
    @State private var isValidId = false
    @State private var navigateToBoardView = false
    @State private var showButtons = false
    @State private var showCrateView: Bool = false
    @State private var chosenSession: String?
    
    @State private var navigationPath = NavigationPath()

    @Query private var items: [SessionPanel]
    @Environment(\.modelContext) var context
    
    var horizontalItems = ["1","2","3","4"]
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.userSessions.isEmpty {
                    NoDataView()
                } else {
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
                            ForEach(viewModel.userSessions) { item in
                                HStack {
                                    Image(item.backgroundImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 40)
                                        .cornerRadius(8)
                                        .clipped()
                                        .contentShape(Rectangle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.sessionName)
                                            .foregroundColor(.black)
                                            .font(.title3)
                                        Text(item.createdTime.dateValue().formatted(date: .abbreviated, time: .omitted))
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.leading, 16)
                                    .padding(.vertical, 4)

                                    Spacer()

                                    Button {
                                        navigateToBoardView = true
                                    } label: {
                                        Text("")
                                    }

                                    NavigationLink(destination: BoardView(
                                        sessionId: item.sessionId,
                                        currentUserName: item.userName,
                                        showCreateView: $showCrateView,
                                        chosenBackground: item.backgroundImage
                                    ), isActive: $navigateToBoardView) {
                                        EmptyView()
                                    }
                                }
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }

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
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(spacing: 4) {
                                Text("Session Id")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack {
                                    TextField("Session Id", text: $sessionId)
                                        .padding(12)
                                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                                        .cornerRadius(8)
                                }
                                .padding([.leading, .trailing], 24)
                            }
                            VStack(spacing: 4) {
                                Text("Session Password")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack {
                                    SecureField("Session Password", text: $sessionPassword)
                                        .padding(12)
                                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                                        .cornerRadius(8)
                                }
                                .padding([.leading, .trailing], 24)
                            }

                            VStack(spacing: 4) {
                                Text("NickName")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                HStack {
                                    TextField("Nickname", text: $userName)
                                        .padding(12)
                                        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                                        .cornerRadius(8)
                                }
                                .padding([.leading, .trailing], 24)
                            }

                            HStack {
                                NavigationLink(destination: BoardView(sessionId: self.sessionId, currentUserName: userName, showCreateView: $showCrateView), isActive: $isValidId) {
                                    Button(action: {
                                        isLoading = true
                                        viewModel.joinSession(sessionId, sessionPassword: sessionPassword) { isValid in
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
                                            Text("Find Session")
                                                .foregroundColor(.white)
                                                .frame(width: 120, height: 45)
                                                .background(Color.cyan)
                                                .cornerRadius(4)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)
                        }
                        .frame(width: 300, height: 330)
                        .background(.white)
                        .cornerRadius(10)
                        .position(x: geometry.size.width / 2, y: (geometry.size.height - geometry.safeAreaInsets.top + 30) / 2)
                        .transition(.scale)
                    }
                }
            }
            .onAppear {
                showButtons = false
                viewModel.fetchUserSessions()
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
