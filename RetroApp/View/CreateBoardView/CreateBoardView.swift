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
    @State private var alertMessage: String = ""
    @State private var navigateToBoardView = false
    @State private var isListVisible: Bool = false
    @State private var chosenRetroStyle: String = "Went Well - To Improve - Action Items"
    @State private var chosenRetroIndex: Int = 0
    @State private var isAnonym: Bool = false
    @State private var isTimer: Bool = false
    @State private var timeValue: Double = 5
    @State private var sessionId: String = ""
    @State private var sessionPassword: String = "123456"

    @ObservedObject var viewModel = CreateBoardViewModel()
    @State private var item = SessionPanel()
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Panel İsmi")
                            .font(.headline)
                            .padding(.top, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                        
                        TextField("Enter board name", text: $sessionName)
                            .padding(12)
                            .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                        
                        Text("Görünecek Kullanıcı Adı")
                            .font(.headline)
                            .padding(.top, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                        
                        TextField("Nick Name", text: $userName)
                            .padding(12)
                            .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                        
                        Text("Session Password")
                            .font(.headline)
                            .padding(.top, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                        
                        TextField("Password", text: $sessionPassword)
                            .padding(12)
                            .background(Color(red: 0.99, green: 0.99, blue: 0.99))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                        
                        Text("Retro Style")
                            .font(.headline)
                            .padding(.top, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .fill(Color(red: 0.99, green: 0.99, blue: 0.99))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            .overlay(
                                HStack {
                                    Text(chosenRetroStyle)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                            )
                            .frame(minHeight: 50)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isListVisible.toggle()
                                }
                            }
                        
                        VStack {
                            HStack {
                                Text("Pano Arkaplanı")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Image("\((selectedColorIndex ?? 0)+1)")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(8)
                                    .clipped()
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                isColorPalettePresented = true
                            }
                        }

                        
                        if isListVisible {
                            VStack {
                                List {
                                    ForEach(viewModel.retroStyles, id: \.self) { style in
                                        Button {
                                            print(style)
                                            chosenRetroStyle = style
                                            isListVisible.toggle()
                                        } label: {
                                            Text("\(style)")
                                        }
                                        
                                    }
                                }
                                .listStyle(PlainListStyle())
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .frame(width: UIScreen.main.bounds.width - 32, height: 180)
                                .transition(.move(edge: .bottom))
                            }
                            .animation(.easeInOut(duration: 0.5))
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        HStack (){
                            Button(action: {
                                isAnonym.toggle()
                            }) {
                                Image(systemName: isAnonym ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isAnonym ? .cyan : .primary)
                                    .imageScale(.large)
                            }
                            Text("Kullanıcılar anonim olarak giriş yapsın.")
                                .font(.body)
                                .onTapGesture {
                                    isAnonym.toggle()
                                }
                        }
                        .padding(.top, 8)
                        
                        HStack (){
                            Button(action: {
                                isTimer.toggle()
                            }) {
                                Image(systemName: isTimer ? "checkmark.square.fill" : "square")
                                    .foregroundColor(isTimer ? .cyan : .primary)
                                    .imageScale(.large)
                            }
                            Text("Session için zamanlayıcı koy.")
                                .font(.body)
                                .onTapGesture {
                                    isTimer.toggle()
                                }
                        }
                        .padding(.top, 8)
                        
                        if isTimer {
                            Text("Güncel Ayarlanan Zaman \(Int(timeValue))")
                                .padding(.top, 8)
                            Slider(value: $timeValue, in: 1...10, step: 1)
                                .padding(.top, 8)
                            
                        }
                        
                    }
                    .padding(.horizontal, 16)
    
                    Button(action: {
                        sessionId = generateRandomSessionID(length: 6)
                        context.insert(SessionPanel(sessionId: sessionId, sessionName: sessionName, userName: userName, sessionBackground: "\(selectedColorIndex+1)"))
                        let user = User(sessionId: sessionId, sessionName: sessionName, userName: userName, backgroundImage: "\(selectedColorIndex+1)")
                        viewModel.saveUserSession(user: user)
                        createSession()
                        navigateToBoardView = true
                        //navigateToNewPage = true

                    }) {
                        Text("Kaydet")
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .background(Color.cyan)
                            .cornerRadius(8)
                    }
                    .offset(y: 30)
                    
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
                Alert(title: Text("Pano Eklenemedi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
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
        viewModel.createSession(createdBy: userName, sessionId: sessionId, sessionPassword: sessionPassword, timer: Int(timeValue)*60, sessionName: sessionName, isAnonym: isAnonym, sessionBackground: "\(selectedColorIndex+1)")
        
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




