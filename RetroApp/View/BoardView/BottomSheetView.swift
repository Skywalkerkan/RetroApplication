//
//  BottomSheetView.swift
//  RetroApp
//
//  Created by Erkan on 6.08.2024.
//

import SwiftUI

struct BottomSheetView: View {
    
    @State var descriptionString: String

    var body: some View {
            VStack (alignment: .leading, spacing: 8) {
                Text("Buraya teBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıBuraya text girilecek tamam mıxt girilecek tamam mı")
                Text("İsimsiz panelindeki erkan listesinde")
                
                TextEditor(text: $descriptionString)
                    .frame(minHeight: 40, alignment: .leading)
                    .frame(maxHeight: 300)
                    .cornerRadius(10, antialiased: true)
                    .foregroundColor(.black)
                    .font(.body)
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)

            }

        }
}

struct BottomSheetView_Previews: PreviewProvider {
    @State static var descriptionString = "Initial text"
    
    static var previews: some View {
        BottomSheetView(descriptionString: "Erkan")
    }
}

