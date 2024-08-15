//
//  NoDataView.swift
//  RetroApp
//
//  Created by Erkan on 14.08.2024.
//

import SwiftUI

struct NoDataView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 16) {
                Image("colleagues")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                
                Text("Create or join a session \n easily")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .offset(y: -UIScreen.main.bounds.height*0.04)
                
                Text("You can easily create a session \n and have great retros with \n your friends.")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .offset(y: -UIScreen.main.bounds.height*0.04)
            }
            .frame(width: geometry.size.width)
            .background(Color.clear)
            .cornerRadius(8)
            .position(
                x: geometry.size.width / 2,
                y: (geometry.size.height / 2) - (geometry.size.height * 0.1)
            )
        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    NoDataView()
}
