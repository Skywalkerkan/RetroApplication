//
//  PanelCell.swift
//  RetroApp
//
//  Created by Erkan on 25.07.2024.
//

import SwiftUI

struct PanelCell: View {
    let panelName: String?
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 50, height: 30)
                .foregroundColor(.red)
            Text(panelName ?? "none")
                .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                .padding(12)
                .cornerRadius(8)
        }
    }
}

#Preview {
    PanelCell(panelName: "Panel 1")
}
