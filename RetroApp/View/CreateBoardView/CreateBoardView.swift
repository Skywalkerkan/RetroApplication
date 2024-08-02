//
//  CreateBoardView.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct CreateBoardView: View {
    
    @State private var sessionName: String = ""
    @State private var userName: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var navigateToBoardView = false
    @State private var isListVisible: Bool = false
    @State private var chosenRetroStyle: String = "Went Well - To Improve - Action Items"
    @State private var isAnonym: Bool = false
    @State private var isTimer: Bool = false
    @State private var timeValue: Double = 5

    @ObservedObject var viewModel = CreateBoardViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Panel İsmi")
                        .font(.headline)
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                    
                    TextField("Enter board name", text: $sessionName)
                        .padding()
                        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
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
                        .padding()
                        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
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
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .cornerRadius(8)
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
                    /*HStack {
                        Text("Pano Arkaplanı")
                        Spacer()
                        Rectangle()
                            .cornerRadius(4)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40)*/
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                Button(action: {
                    let sessionId = "123456"
                    viewModel.createSession(createdBy: userName, sessionId: sessionId, timer: Int(timeValue)*60, sessionName: sessionName, isAnonym: isAnonym)
                    let board = Board(
                        id: UUID().uuidString,
                        name: "Went Well",
                        cards: [
                            Card(
                                id: UUID().uuidString,
                                description: "We successfully completed the project ahead of the deadline, exceeding all expectations and receiving positive feedback from the client.",
                                userName: "Erkan"
                            )
                        ]
                    )

                    let board2 = Board(
                        id: UUID().uuidString,
                        name: "To Improve",
                        cards: [
                            Card(
                                id: UUID().uuidString,
                                description: "There were some communication gaps between the development team and the stakeholders, leading to delays in certain deliverables.",
                                userName: "Kerem"
                            ),
                            Card(
                                id: UUID().uuidString,
                                description: "The code review process was sometimes slow, causing bottlenecks in the development pipeline and delaying the integration of new features.",
                                userName: "Ahmet"
                            ),
                            Card(
                                id: UUID().uuidString,
                                description: "We need to improve our testing procedures to ensure higher code quality and reduce the number of bugs found in production.",
                                userName: "Mehmet"
                            )
                        ]
                    )

                    let board3 = Board(
                        id: UUID().uuidString,
                        name: "Action Items",
                        cards: [
                            Card(
                                id: UUID().uuidString,
                                description: "Implement a weekly meeting to discuss ongoing projects and ensure all team members are aligned on priorities and deadlines.",
                                userName: "Erkan"
                            ),
                            Card(
                                id: UUID().uuidString,
                                description: "Create a detailed documentation for the new features to help both the development team and the stakeholders understand the functionalities better.",
                                userName: "Erkan"
                            ),
                            Card(
                                id: UUID().uuidString,
                                description: "Set up automated testing to catch bugs early in the development process and improve overall code quality.",
                                userName: "Erkan"
                            )
                        ]
                    )
                    
                    viewModel.createBoard(sessionId: sessionId, board: board)
                    viewModel.createBoard(sessionId: sessionId, board: board2)
                    viewModel.createBoard(sessionId: sessionId, board: board3)
                    
                    
                    navigateToBoardView = true
                }) {
                    Text("Kaydet")
                        .frame(width: 150, height: 40)
                        .foregroundColor(.white)
                        .background(Color.cyan)
                        .cornerRadius(8)
                }
                .padding(.bottom, 64)
                
                NavigationLink(
                    destination: BoardView().navigationBarTitleDisplayMode(.inline),
                    isActive: $navigateToBoardView,
                    label: { EmptyView() }
                )
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Pano Eklenemedi"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
            .navigationTitle("Pano Oluştur")
            

        }
    }
}

#Preview {
    CreateBoardView()
}



