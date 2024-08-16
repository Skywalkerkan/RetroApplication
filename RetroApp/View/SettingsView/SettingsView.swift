//
//  SettingsView.swift
//  RetroApp
//
//  Created by Erkan on 8.08.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State var sessionId: String
    @StateObject var viewModel = SettingsViewModel()
    @State private var isAnonymous: Bool = false
    @State private var isTimerActive: Bool = false
    @State private var timerMinutes: Int = 0
    @State private var isTimer = false
    @State private var allowUserChange: Bool = false
    @State private var lastTime: Date?
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    @State private var showDeleteConfirmation = false

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Infos")) {
                    HStack {
                        Text("Created By:")
                        Spacer()
                        Text(viewModel.session?.createdBy ?? "N/A")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Session Name:")
                        Spacer()
                        Text(viewModel.session?.sessionName ?? "N/A")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Session Id:")
                        Spacer()
                        Text(viewModel.session?.id ?? "N/A")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Session Password:")
                        Spacer()
                        Text(viewModel.session?.sessionPassword ?? "N/A")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Boards Count:")
                        Spacer()
                        Text("\(viewModel.session?.boards.count ?? 0)")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Session Settings")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Toggle("Anonymous", isOn: $isAnonymous)
                                .onChange(of: isAnonymous) { newValue in
                                    //isAnonymous.toggle()
                                }
                        }
                        Text("Adjust all cards as anonymous.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    if timeRemaining == 0 && !isTimerActive {
                        HStack {
                            Toggle("Timer", isOn: $isTimer)
                            
                        }
                    }
                    
                    if (isTimerActive) && isTimer || ((timeRemaining) != 0){
                        HStack(alignment: .center, spacing: 16) {
                            Text("Time Remaining:")
                                .font(.headline)
                            Spacer()
                                .font(.body)
                            HStack {
                                Spacer()
                                Button(action: {
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
                                .buttonStyle(PlainButtonStyle())
                                Text(" \(timeRemaining / 60) : \(timeRemaining % 60)")
                                Button(action: {
                                    viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: false, timer: timerMinutes, timeRemains: nil, allowUserChange: true)
                                }) {
                                    Image(systemName: "stop.fill")
                                        .foregroundColor(.black)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                        }
                        
                    }
                    
                    else if isTimer {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Timer Duration:")
                                .font(.headline)
                            
                            HStack {
                                Text("Minutes:")
                                    .frame(width: 80, alignment: .leading)
                                
                                Stepper(value: $timerMinutes, in: 1...120, step: 1) {
                                    Text("\(Int(timerMinutes)) minutes")
                                }
                                .frame(maxWidth: .infinity)
                            }

                            HStack {
                                Toggle("Allow user to make changes when timer runs out.", isOn: $allowUserChange)
                            }
                            
                            Text("Adjust the duration using the stepper or enter a value directly.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
 
                }
                
                Button {
                    saveSettings()
                } label: {
                    Text("Save Settings")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)
            }
            
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            })
            .navigationBarItems(trailing: Button(action: {
                showDeleteConfirmation.toggle()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            })
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteSession(for: sessionId)
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action will permanently delete the session. Are you sure you want to proceed?")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        .onAppear {
            viewModel.getSessionSettings(sessionId: sessionId) { success in
                if success {
                    if let session = viewModel.session {
                        isAnonymous = session.isAnonym
                        isTimer = session.isTimerActive ?? false
                        isTimerActive = session.isTimerActive ?? false
                        lastTime = session.timerExpiresDate?.dateValue()
                        timeRemaining = session.timeRemains ?? 0
                        if isTimer {
                            startTimer()
                        }
                        if timeRemaining != 0 && !isTimer{
                            stopTimer()
                        }
                    }
                }
            }
        }
    }
    
    private func startTimer() {
        guard let lastTime = lastTime else { return }
        
        let currentTime = Date()
        let timeInterval = lastTime.timeIntervalSince(currentTime)
        timeRemaining = Int(max(timeInterval, 0))
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: false, timer: timeRemaining, timeRemains: nil, allowUserChange: allowUserChange)
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    
    func saveSettings() {
        if (isTimerActive) && (timeRemaining > 0) {
            viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: isTimer, timer: timeRemaining, timeRemains: nil, allowUserChange: true)
        } else {
            viewModel.addSettingsToSession(sessionId: sessionId, isAnonymous: isAnonymous, isTimerActive: isTimer, timer: timerMinutes*60, timeRemains: nil, allowUserChange: true)
        }
        isTimerActive = isTimer
        startTimer()
    }
}
