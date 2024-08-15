//
//  CreateBoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct CreateBoardView: View {
    
    @Binding var showCreateView: Bool
    @State private var selectedColorIndex: Int = 0
    @State private var isColorPalettePresented = false
    @State var imageName: String  = "1"
    @State private var navigateToNewPage = false
    @State private var sessionName: String = ""
    @State private var userName: String = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage: String = ""
    @State private var navigateToBoardView = false
    @State private var isListVisible: Bool = false
    @State private var chosenRetroStyle: String = "Went Well - To Improve - Action Items"
    @State private var chosenRetroIndex: Int = 0
    @State private var isAnonym: Bool = false
    @State private var isTimer: Bool = false
    @State private var sessionId: String = ""
    @State private var sessionPassword: String = ""
    @State private var timerMinutes: Int = 5
    @State private var timerMinutesInput: String = "5"

    @ObservedObject var viewModel = CreateBoardViewModel()
    @State private var item = SessionPanel()
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Session Name")
                                .font(.headline)
                            TextField("Enter session name", text: $sessionName)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.lightGray), lineWidth: 0.5)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Session Password")
                                .font(.headline)
                            SecureField("Enter session password", text: $sessionPassword)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.lightGray), lineWidth: 0.5)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("User Nickname")
                                .font(.headline)
                            TextField("Enter your nickname", text: $userName)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.lightGray), lineWidth: 0.5)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Choose Retro Style")
                                .font(.headline)
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                    isListVisible.toggle()
                                }
                            }) {
                                HStack {
                                    Text(chosenRetroStyle.isEmpty ? "Select option" : chosenRetroStyle)
                                        .foregroundColor(chosenRetroStyle.isEmpty ? .gray : .black)
                                    Spacer()
                                    Image(systemName: isListVisible ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.lightGray), lineWidth: 0.5)
                                )
                            }
                            
                            if isListVisible {
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    ForEach(viewModel.retroStyles.indices, id: \.self) { index in
                                        Text("\(viewModel.retroStyles[index])")
                                            .padding(12)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.clear)
                                            .onTapGesture {
                                                chosenRetroStyle = "\(viewModel.retroStyles[index])"
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                                    isListVisible = false
                                                }
                                            }
                                        if index != 4 {
                                            Divider()
                                        }
                                    }
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.lightGray), lineWidth: 0.5)
                                )
                                .scaleEffect(isListVisible ? 1 : 0.9)
                                .opacity(isListVisible ? 1 : 0)
                            }
                        }
                        
                        VStack {
                            Button(action: {
                                print("Select background tapped")
                                isColorPalettePresented = true
                            }) {
                                HStack {
                                    Text("Session background: ")
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image("\((selectedColorIndex)+1)")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(8)
                                        .clipped()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        HStack (){
                            Button(action: {
                                isAnonym.toggle()
                            }) {
                                Image(systemName: isAnonym ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isAnonym ? .cyan : .primary)
                                    .imageScale(.large)
                            }
                            Text("Let users log in anonymously.")
                                .font(.body)
                                .onTapGesture {
                                    isAnonym.toggle()
                                }
                        }
                        .padding(.top, -4)
                        
                        HStack (){
                            Button(action: {
                                isTimer.toggle()
                            }) {
                                Image(systemName: isTimer ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isTimer ? .cyan : .primary)
                                    .imageScale(.large)
                            }
                            Text("Set timer for the session.")
                                .font(.body)
                                .onTapGesture {
                                    isTimer.toggle()
                                }
                        }
                        .padding(.top, 0)
                        
                        if isTimer {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Set Timer (in minutes)")
                                    .font(.headline)
                                
                                HStack {
                                    Stepper(
                                        value: $timerMinutes,
                                        in: 0...120,
                                        step: 1
                                    ) {
                                        HStack {
                                            Text("Duration: ")
                                            TextField("Minutes", text: $timerMinutesInput)
                                                .keyboardType(.numberPad)
                                                .padding(12)
                                                .background(Color(.white))
                                                .cornerRadius(10)
                                                .frame(width: 50)
                                                .multilineTextAlignment(.center)
                                            Text("minutes")
                                        }
                                    }
                                    .onChange(of: timerMinutes) { newValue in
                                        timerMinutesInput = String(newValue)
                                    }
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal, 16)
                    
                    
                    Button(action: {
                        if sessionName.isEmpty || sessionPassword.isEmpty || userName.isEmpty {
                            alertTitle = "Missing Information"
                            alertMessage = "Please fill in all required fields."
                            showAlert = true
                        } else {
                            sessionId = generateRandomSessionID(length: 6)
                            context.insert(SessionPanel(sessionId: sessionId, sessionName: sessionName, userName: userName, sessionBackground: "\(selectedColorIndex+1)"))
                            let user = User(sessionId: sessionId, sessionName: sessionName, userName: userName, backgroundImage: "\(selectedColorIndex+1)")
                            viewModel.saveUserSession(user: user)
                            createSession()
                            navigateToBoardView = true
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 16)
                    
                    NavigationLink(
                        destination: BoardView(sessionId: sessionId, currentUserName: userName, showCreateView: $showCreateView).navigationBarTitleDisplayMode(.inline),
                        isActive: $navigateToBoardView,
                        label: { EmptyView() }
                    )
                }
            }
            .fullScreenCover(isPresented: $isColorPalettePresented) {
                ColorPaletteView(selectedIndex: $selectedColorIndex)
                    .onChange(of: selectedColorIndex) { newIndex in
                        
                    }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showCreateView = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Pano Oluştur")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func createSession() {
        viewModel.createSession(createdBy: userName, sessionId: sessionId, sessionPassword: sessionPassword, timer: Int(timerMinutes)*60, isTimerActive: isTimer, sessionName: sessionName, isAnonym: isAnonym, sessionBackground: "\(selectedColorIndex+1)")
        
        for retroName in viewModel.boardRetroNames {
            if retroName.key == chosenRetroStyle {
                let boardNames = retroName.value
                for boardName in boardNames {
                    print("Retro Style: \(retroName.key), Board Name: \(boardName)")
                    
                    let board = Board(id: UUID().uuidString, name: boardName, cards: [])
                    viewModel.createBoard(sessionId: sessionId, board: board)
                    
                }
            }
        }
    }
    
    func generateRandomSessionID(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray = Array(characters)
        var randomString = ""

        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(charactersArray.count)))
            randomString.append(charactersArray[randomIndex])
        }
        return randomString
    }
}




