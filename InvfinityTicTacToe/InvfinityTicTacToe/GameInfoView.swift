//
//  GameInfoView.swift
//  InvfinityTicTacToe
//
//  Created by Лев Куликов on 12.05.2024.
//

import SwiftUI

struct GameInfoView: View {
    //MARK: - Propeties
    var namespace: Namespace.ID
    @Binding var showInfo: Bool
    @Binding var selectedGame: GameType?
    @Binding var gameScheme: [Int : TicTacToeMark?]
    @Binding var markPositions: [TicTacToeMark: [Int]]
    
    //MARK: - Body
    var body: some View {
        VStack {
            
            VStack(alignment: .leading) {
                HStack {
                    Text(selectedGame?.rawValue ?? "Game Title")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button("", systemImage: "xmark") {
                        closeInfo()
                    }
                    .font(.title2)
                    .tint(.secondary)
                }
                
                Text("Only three figures of each side can be on the field. If fourth added, the first one disappears")
                    .padding(.vertical)
                
                Button {
                    restartGameAndCloseInfo()
                } label: {
                    Text("Restart")
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    closeGame()
                } label: {
                    Text("Close Game")
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.red)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(Material.ultraThin)
            }
            .frame(maxWidth: 400)
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .onTapGesture(perform: closeInfo)
        }
        .ignoresSafeArea()
    }
    
    //MARK: - Methods
    
    private func closeInfo() {
        withAnimation(.snappy) {
            showInfo = false
        }
    }
    
    private func restartGameAndCloseInfo() {
        withAnimation(.snappy) {
            for index in gameScheme.keys {
                gameScheme[index] = nil
            }
            
            for index in markPositions.keys {
                markPositions[index] = []
            }
        }
        closeInfo()
    }
    
    private func closeGame() {
        withAnimation(.snappy) {
            selectedGame = nil
        }
    }
}

#Preview {
    @Namespace var namespace
    @State var showInfo = true
    @State var selectedGame: GameType? = .onlyThree
    @State var gameScheme: [Int : TicTacToeMark?] = [
        0 : nil,
        1 : nil,
        2 : nil,
        3 : nil,
        4 : nil,
        5 : nil,
        6 : nil,
        7 : nil,
        8 : nil,
    ]
    @State var markPositions: [TicTacToeMark: [Int]] = [
        .xmark : [],
        .omark : []
    ]
    
    return GameInfoView(namespace: namespace, 
                        showInfo: $showInfo,
                        selectedGame: $selectedGame,
                        gameScheme: $gameScheme,
                        markPositions: $markPositions)
}
