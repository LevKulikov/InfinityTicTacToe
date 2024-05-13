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
    @Binding var winner: TicTacToeMark?
    @Binding var gameScheme: [Int : TicTacToeMark?]
    @Binding var markPositions: [TicTacToeMark: [Int]]
    
    //MARK: - Body
    var body: some View {
        VStack {
            infoView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .onTapGesture(perform: closeInfo)
        }
        .ignoresSafeArea()
    }
    
    private var infoView: some View {
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
        .matchedGeometryEffect(id: "gameInfo", in: namespace)
    }
    
    //MARK: - Methods
    private func closeInfo() {
        withAnimation(.easeOut) {
            showInfo = false
        }
    }
    
    private func restartGameAndCloseInfo() {
        closeInfo()
        restartGame()
    }
    
    private func restartGame() {
        withAnimation(.snappy) {
            winner = nil
            
            for index in gameScheme.keys {
                gameScheme[index] = nil
            }
            
            for index in markPositions.keys {
                markPositions[index] = []
            }
        }
    }
    
    private func closeGame() {
        restartGameAndCloseInfo()
        withAnimation(.snappy(duration: 0.4)) {
            selectedGame = nil
        }
    }
}

#Preview {
    @Namespace var namespace
    @State var showInfo = true
    @State var selectedGame: GameType? = .onlyThree
    @State var winner: TicTacToeMark? = nil
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
                        winner: $winner,
                        gameScheme: $gameScheme,
                        markPositions: $markPositions)
}
