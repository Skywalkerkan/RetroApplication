//
//  InfoView.swift
//  RetroApp
//
//  Created by Erkan on 1.08.2024.
//

import SwiftUI

struct InfoView: View {
    var infoText: String

    var body: some View {
        VStack(alignment: .center) {
            Text(infoText)
                .multilineTextAlignment(.center)
        }
        .frame(height: 50)
        .background(Color.green)
    }
}

/*
#Preview {
    InfoView()
}*/
