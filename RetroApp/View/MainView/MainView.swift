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
    @State private var sessionPassword: String = ""
    @State private var userName: String = ""
    @State private var isLoading = false
    @State private var isValidId = false
    @State private var navigateToBoardView = false
    @State private var showButtons = false
    @State private var showCrateView: Bool = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
        
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.userSessions.isEmpty {
                    NoDataView()
                } else {
                    List {
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
                            .onDelete(perform: deleteUserSession)
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
                                        .onChange(of: sessionId) { newValue in
                                            sessionId = newValue.uppercased()
                                        }
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
                                        print(sessionId, sessionPassword, userName)
                                        if sessionId.isEmpty || sessionPassword.isEmpty || userName.isEmpty {
                                            alertTitle = "Missing Information"
                                            alertMessage = "Please fill in all required fields."
                                            showAlert = true
                                        } else {
                                            isLoading = true
                                            viewModel.joinSession(sessionId, sessionPassword: sessionPassword) { isValid in
                                                isLoading = false
                                                isValidId = isValid
                                                if isValid {
                                                    print("Valid session ID")
                                                } else if let error = viewModel.error {
                                                    alertTitle = "Error"
                                                    alertMessage = error.localizedDescription
                                                    showAlert = true
                                                } else {
                                                    alertTitle = "Invalid Session"
                                                    alertMessage = "The session ID or password is incorrect. Please try again."
                                                    showAlert = true
                                                }                                            }
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
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text(alertTitle),
                                    message: Text(alertMessage),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
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
                showSessionFinder = false
                viewModel.fetchUserSessions()
            }
            .navigationBarTitle("Retrospective", displayMode: .inline)
        }
    }
    
    func deleteUserSession(at offsets: IndexSet) {
        let indices = offsets.map { $0 }
                
        for index in indices {
            let userSession = viewModel.userSessions[index]
            viewModel.deleteUserSession(for: userSession.sessionId)
        }

    }


    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
