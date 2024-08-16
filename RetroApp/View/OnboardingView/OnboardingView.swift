//
//  OnboardingView.swift
//  RetroApp
//
//  Created by Erkan on 16.08.2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    private let totalPages = 3
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(imageName: "1", title: "Kartları Sürükle", description: "Şikayet kartlarını farklı kategorilere sürükleyerek tartışmayı organize et.")
                .tag(0)
            OnboardingPage(imageName: "2", title: "Geri Bildirim Ver", description: "Kartlara geri bildirim ekleyin ve takımınızla paylaşın.")
                .tag(1)
            OnboardingPage(imageName: "3", title: "İlerlemenizi Görüntüleyin", description: "Kartlar tamamlandığında, ilerlemenizi takip edin.")
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle())
        .overlay(
            VStack {
                Spacer()
                if currentPage == totalPages - 1 {
                    Button(action: {

                    }) {
                        Text("Başlayalım!")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
            }
        )
    }
}

struct OnboardingPage: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.top, 50)
            
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
    }
}
