//
//  BoardViewModel.swift
//  RetroApp
//
//  Created by Erkan on 26.07.2024.
//

import Foundation

class BoardViewModel: ObservableObject {
    
    private var firebaseManager = FirebaseManager()
   /* @Published var panels: [Panel] = []
    @Published var boards: [Board] = []
    @Published var boardList: [BoardList] = []
    @Published var listItems: [ListItem] = []
    @Published var actualListItems: [[ListItem]] = []
    
    func fetchPanel() {
        firebaseManager.observePanels { result in
            switch result {
            case .success(let panels):
                self.panels = panels
                if let firstPanel = panels.first, let panelID = firstPanel.id {
                    self.firebaseManager.observeBoards(for: panelID) { result in
                        switch result {
                        case .success(let boards):
                            self.boardList.removeAll()
                            self.listItems.removeAll()
                            self.actualListItems.removeAll()
                            
                            for board in boards {
                                self.boardList.append(board.list)
                            }
                            
                            for list in self.boardList {
                                self.listItems.append(contentsOf: list.items)
                            }
                            print("List Items1: \(self.listItems.count)")

                            for list in self.boardList {
                                self.actualListItems.append(list.items)
                            }
                            
                            print("List Items: \(self.actualListItems.count)")
                            
                        case .failure(let error):
                            print("Error observing boards: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error observing panels: \(error)")
            }
        }
    }
*/
}
