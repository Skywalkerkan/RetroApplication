//
//  BoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct BoardView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding private var showCreateView: Bool
    @State private var showSessionExpiredAlert = false
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var isAddBoarding: Bool = false
    @State private var addBoardTextField: String = ""
    @State private var currentUserName: String
    @State private var chosenBackground: String
    @State private var showSettings = false
    @State private var isAnonymous: Bool = false
    @State private var isTimerActive: Bool = false
    @State private var timerMinutes: Int = 0
    @State private var isTimer = false
    @State private var allowUserChange: Bool = false
    @State private var lastTime: Date?
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    
    @StateObject var viewModel = BoardViewModel()
    @FocusState private var isTextFieldFocused: Bool
    var sessionId: String
    
    init(sessionId: String, currentUserName: String, showCreateView: Binding<Bool>, chosenBackground: String = "2") {
        self.sessionId = sessionId
        self.currentUserName = currentUserName
        _showCreateView = showCreateView
        self.chosenBackground = chosenBackground
    }
 
    var body: some View {

        VStack {
            ScrollView(.horizontal) {
                ScrollViewReader { proxy in
                    HStack(spacing: 4) {
                        ForEach(viewModel.boards.indices, id: \.self) { index in
                            DroppableList(viewModel.boards[index].name, boardIndex: index, cards: $viewModel.boards[index].cards, sessionId: self.sessionId, isAnonym: viewModel.session?.isAnonym ?? false, currentUserName: currentUserName) { dropped, index, boardActualIndex in
                                print(dropped.id ,index, boardActualIndex)
                                
                                var boardIndex = 0
                                var cardIndex = 0
                                var cardIndex2 = 0
                                var boardIndex2 = 0
                                var found = false
                                
                                var cardActual: Card?
                                for board in viewModel.boards {
                                    for card in board.cards {
                                        if card.id == dropped.id {
                                            cardActual = Card(id: card.id, description: card.description, userName: card.userName)
                                            found = true
                                            break
                                        }
                                        cardIndex += 1
                                    }
                                    if found { break }
                                    cardIndex = 0
                                    boardIndex += 1
                                }
                                
                                for board in viewModel.boards {
                                    for card in board.cards {
                                        if card.id == dropped.id {
                                            print("cardid \(card.id)")
                                            break
                                        }
                                        print(card.id)
                                    }
                                    boardIndex2 += 1
                                }
                                
                                viewModel.boards = viewModel.boards.map { board in
                                    var updatedBoard = board
                                    print()
                                    updatedBoard.cards.removeAll { $0.id == dropped.id }
                                    return updatedBoard
                                }
                                
                                viewModel.boards[boardActualIndex].cards.insert(cardActual ?? Card(id: "12345", description: "12345", userName: "Erkan1"), at: index)
                                
                                viewModel.updateBoards(sessionId: sessionId, boards: viewModel.boards)
                                
                            }
                            .padding(.top, -4)
                            .frame(width: 300)
                        }
                        
                        VStack {
                            if !isAddBoarding {
                                
                                Button {
                                    isAddBoarding.toggle()
                                    isTextFieldFocused.toggle()
                                } label: {
                                    Text("Board Oluştur")
                                        .frame(width: 300, height: 50)
                                }
                                .background(Color.black)
                                .cornerRadius(8)
                                Spacer()
                            } else {
                                TextField("Liste Adı", text: $addBoardTextField)
                                    .frame(width: 270)
                                    .padding()
                                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                                    .focused($isTextFieldFocused)

                                Spacer()

                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))

                }
            }
            .background(
                Image(viewModel.session?.sessionBackground ?? chosenBackground)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, 0)
        }
        

        .onAppear {
            viewModel.startSessionExpirationTimer(for: sessionId)
            viewModel.fetchBoards(sessionId: sessionId)
          //  print(user)
            print("Started session expiration timer.")
            viewModel.getSessionSettings(sessionId: sessionId) { success in
                if success {
                    if let session = viewModel.session {
                        isAnonymous = session.isAnonym
                        isTimer = session.isTimerActive ?? false
                        isTimerActive = session.isTimerActive ?? false
                        timeRemaining = session.timeRemains ?? 0
                        if timeRemaining != 0 {
                            stopTimer()
                        }
                        lastTime = session.timerExpiresDate?.dateValue()
                        if isTimer {
                            startTimer()
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.session) { newSession in
            if let session = newSession {
                let user = User(sessionId: sessionId, sessionName: viewModel.session?.sessionName ?? "Anonymous", userName: currentUserName, backgroundImage: viewModel.session?.sessionBackground ?? "1")
                viewModel.saveUserSession(user: user)
            } else {
                
            }
        }
       /* .alert(isPresented: $showSessionExpiredAlert) {
            return Alert(
                title: Text("Oturum Süresi Doldu"),
                message: Text("Bu oturumun süresi doldu. Lütfen yeni bir oturum oluşturun."),
                dismissButton: .default(Text("Tamam"))
            )
        }*/
        .onReceive(viewModel.$showSessionExpiredAlert) { showAlert in
            print("Received alert: \(showAlert)")
            showSessionExpiredAlert = showAlert
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if !showCreateView {
                        presentationMode.wrappedValue.dismiss()
                    }
                    showCreateView = false
                }) {
                    Image(systemName: "arrowshape.backward.fill")
                        .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if isAddBoarding {
                    Button(action: {
                        viewModel.createBoard(sessionId: sessionId, board: Board(id: UUID().uuidString, name: addBoardTextField, cards: []))
                        isAddBoarding.toggle()
                        addBoardTextField = ""
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if isAddBoarding {
                    Button(action: {
                        isAddBoarding.toggle()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if isAddBoarding {
                    Text("Listeye ekle")
                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack {
                    Button(action: {
                        print("Stop button tapped")
                        if isTimerActive {
                            print("üstteki")
                            stopTimer()
                            viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: false, timer: timeRemaining, timeRemains: timeRemaining, allowUserChange: true)
                        } else {
                            print("alttaki")
                            if timeRemaining != 0{
                                viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: true, timer: timeRemaining, timeRemains: nil, allowUserChange: true)
                                startTimer()
                            } else {
                                viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: false, timer: timeRemaining, timeRemains: nil, allowUserChange: true)
                            }
                        }
                        if timeRemaining != 0{
                            print("time remains \(timeRemaining)")
                            isTimerActive.toggle()
                        }
                    }) {
                        Image(systemName: isTimerActive ? "pause.fill" : "play.fill")
                            .foregroundColor(.black)
                    }
                    Text(" \(timeRemaining / 60) : \(timeRemaining % 60)")
                    Button(action: {
                        print("Play button tapped")
                    }) {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        
        .navigationBarItems(trailing:
            Button(action: {
                self.showSettings.toggle()
            }) {
                Image(systemName: "gear")
                    .imageScale(.large)
                    .padding(.leading, 16)
                    .foregroundColor(.black)
            }
        )
        
        .fullScreenCover(isPresented: $showSettings, content: {
            SettingsView(sessionId: sessionId)
        })
        
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startTimer() {
        print(timeRemaining)

        guard let lastTime = lastTime else { return }
        
        let currentTime = Date()
        let timeInterval = lastTime.timeIntervalSince(currentTime)
        timeRemaining = Int(max(timeInterval, 0)) + timeRemaining
        if timeRemaining == 0 {
            isTimerActive = false
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                isTimerActive = false
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func handleScrollIfNeeded(yPosition: CGFloat, in geometry: GeometryProxy) {
        print(UIScreen.main.bounds.width)

        guard let proxy = scrollViewProxy else { return }
        let screenHeight = UIScreen.main.bounds.height
        let scrollThreshold: CGFloat = 30
        let scrollAmount: CGFloat = 20
        if yPosition < scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(yPosition - scrollAmount, anchor: .top)
            }
        } else if yPosition > screenHeight - scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(yPosition + scrollAmount, anchor: .bottom)
            }
        }
    }

    func handleScrollIfNeeded(xPosition: CGFloat, in geometry: GeometryProxy) {
        print(UIScreen.main.bounds.width)

        guard let proxy = scrollViewProxy else { return }
        let screenWidth = UIScreen.main.bounds.width
        let scrollThreshold: CGFloat = 30
        let scrollAmount: CGFloat = 20
        print(scrollThreshold)
        if xPosition < scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(xPosition - scrollAmount, anchor: .leading)
            }
        } else if xPosition > screenWidth - scrollThreshold {
            withAnimation(.linear(duration: 0.1)) {
                proxy.scrollTo(xPosition + scrollAmount, anchor: .trailing)
            }
        }
    }
}



